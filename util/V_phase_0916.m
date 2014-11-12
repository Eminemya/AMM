param_init

InDir = 'data/';
fid = 1;
fns = {'0Hz_11019fps_0_dl.mat','3100Hz_11019fps_m_dl.mat'};
fns = {'0Hz_11019fps_0_dl.mat','3100Hz_11019fps_s_dl.mat'};
fns = {'0Hz_11019fps_0_dl.mat','3640Hz_11019fps_m_dl.mat'};
%fns = {'0Hz_11019fps_0_dl.mat','3640Hz_11019fps_s_dl.mat'};
fns = {'0Hz_11019fps_0_dl.mat','3640Hz_11019fps_l_dl.mat'};
tt=[1 1000];
%pts = [128 150]; % center
%pts = [119 184]; % on the side bar
pts = [149 163]; % on the horizontal bar
fns = {'simu_60000_3000_10_100_600_1_n1.mat'};tt=[1 600];pts=[68,106];
fns = {'simu_60000_3000_10_100_60_1.mat'};tt=[1 60];pts=[68,106];
pts = [19 82];


phase_sc=2;phase_or=1;
%fns=dir('data/*_dl.mat');fns = {fns.name};
%fns = {'0Hz_11019fps_0_dl.mat','0Hz_11019fps_1_dl.mat'};

%

do_step1= 1;
do_step2= 1;
do_step3= 1;
do_step4= 0;
do_step5= 1; % stat visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('1. Load noisy data\n')
if do_step1
vid = cell(1,numel(fns));
f0s = zeros(1,numel(fns));
f1s = zeros(1,numel(fns));
szs = cell(1,numel(fns));
for i=1:numel(fns)
    vid{i} = load([InDir fns{i}]);
    vid{i}.tmp_vr = vid{i}.tmp_vr(:,:,:,tt(1):tt(2));
    szs{i} = size(vid{i}.tmp_vr);
    %f0s(i) = str2num(fns{i}(find(fns{i}=='_',1,'first')+1:find(fns{i}=='f',1,'first')-1));
    %f1s(i) = str2num(fns{i}(1:find(fns{i}=='_',1,'first')-3));
end
end

% simulation
[yy,xx] = meshgrid(1:szs{1}(2),1:szs{1}(1));
mask = yy>75 & yy<130 & xx>30 & xx<110 & vid{1}.tmp_vr(:,:,1)>0.5;
pts = [xx(mask==1) yy(mask==1)];
f0s(1)=60000;
f1s(1)=3000;
% imagesc(vid{1}.tmp_vr(:,:,1))
win_sz = 0;
% assume the same size
pts_ind = cell(1,numel(fns));

if numel(pts)==2
    % single pt
    for i=1:numel(fns)
        pts_ind{i} = reshape(bsxfun(@plus, (pts(2)-1+(-win_sz:win_sz))*szs{i}(1),pts(1)+(-win_sz:win_sz)'),1,[]);
    end
else
    % n pts
    for i=1:numel(fns)
        pts_ind{i} = pts;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('2. Check the phase\n')
if do_step2
pp = cell(1,numel(fns));
aa = cell(1,numel(fns));

for i=1:numel(fns)
        [pp{i},aa{i}] = T_getPhase3(vid{i}.tmp_vr,'octave_5',phase_sc,phase_or);
end
end

if do_step3
temporalFilter = @FIRWindowBP;
pp_f = cell(1,numel(fns));
for i=1:numel(fns)
    f1 = f1s(i);if(f1==0);f1=f1s(i+1);end
    switch fid 
        case 1  
        fl = ceil(f1*.99);fh = ceil(f1*1.01);
        fs = f0s(i);
        %pp_f{i} = temporalFilter(pp{i}, 0.1,0.4); 
        pp_f{i} = temporalFilter(pp{i}, fl/fs,fh/fs); 
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if do_step4
% visualization
clf,
% phase signal
subplot(411),hold on
cs='brg';
for i=1:numel(fns)
    tmp = reshape(pp{i},[],szs{i}(end));
    tmp_p = tmp(pts_ind{i},:);
    if win_sz~=0;tmp_p=median(tmp_p);end
    %if win_sz~=0;tmp_p=mean(tmp_p);end
    plot(bsxfun(@minus,tmp_p,mean(tmp_p)),[cs(i) '-'])
end
title('original phase')

subplot(412),hold on
cs='brg';
for i=1:numel(fns)
    tmp = reshape(pp_f{i},[],szs{i}(end));
    tmp_p = tmp(pts_ind{i},:);
    if win_sz~=0;tmp_p=mean(tmp_p);end
    plot(bsxfun(@minus,tmp_p,mean(tmp_p)),[cs(i) '--'])
end
title('bandpassed phase')

% fft freq
subplot(413),cla,hold on
for i=1:numel(fns)
    tmp = reshape(pp{i},[],szs{i}(end));
    tmp_p = bsxfun(@minus,tmp(pts_ind{i},:),mean(tmp(pts_ind{i},:),2));
    if win_sz~=0;tmp_p= mean(tmp_p);end
    %tmp_p2 = 10*log10(abs(fft(tmp_p)));
    tmp_p2 = (abs(fft(tmp_p))).^2/numel(tmp_p);
    % cut off
    tmp_p2(1:ceil(szs{i}(end)*0.01))=0;
    tmp_p2(ceil(szs{i}(end)*0.4):end)=0;
    tmp_p2 = tmp_p2(1:end/2);
    
    xx = f0s(i)/numel(tmp_p)*(0:(numel(tmp_p2)-1));    
    plot(xx,tmp_p2,[cs(i) '-'])
end
title('original FFT spectrum')

subplot(414),hold on
for i=1:numel(fns)
    tmp = reshape(pp_f{i},[],szs{i}(end));
    tmp_p = bsxfun(@minus,tmp(pts_ind{i},:),mean(tmp(pts_ind{i},:),2));
    if win_sz~=0;tmp_p= mean(tmp_p);end
    %tmp_p2 = 10*log10(abs(fft(tmp_p)));
    tmp_p2 = (abs(fft(tmp_p))).^2/numel(tmp_p);
    xx = f0s(i)/numel(tmp_p)*(0:(numel(tmp_p2)-1));
    plot(xx,tmp_p2,[cs(i) '-'])
end
title('band-passed FFT spectrum')
%{
subplot(414),hold on
for i=1:numel(fns)
    tmp = reshape(aa{i},[],szs{i}(end));
    tmp_p = tmp(pts_ind{i},:);
    if win_sz~=0;tmp_p=mean(tmp_p);end
    plot(tmp_p,[cs(i) '-'])
end
title('amplitude')
%}
saveas(gcf,sprintf([fns{1}(1:end-4) '_p_%d_%d_%d_%d.jpg'],pts(1),pts(2),win_sz,fid))
end

if do_step5
    V_phase_spatial
end



%{
% 3.2 check single avg over patch
tmp_im_n = double(vid_n.tmp_vr(:,:,1,1));
mask_im = tmp_im_n>mean(tmp_im_n(:));
tmp_a_n = double(a_nm_s600(:,:,1));
mask_a = tmp_a_n>mean(tmp_a_n(:));
mask = mask_a&mask_im;

keyboard
% 3.3 visualize phase heatmap
for i = 1:60%sz(end)
    tmp_p = (p_c(:,:,i)-p_c(:,:,1)).*mask;
    tmp_pn = (p_nm(:,:,i)-p_nm(:,:,1)).*mask;
    tmp_pns60 =(p_nm_s60(:,:,i)).*mask;
    tmp_pns600 =(p_nm_s600(:,:,i)).*mask;
    %imwrite(1e3*[tmp_p tmp_pn tmp_pns],[OutDir 'mask_' num2str(i) '.jpg'])
    imagesc([tmp_p tmp_pn tmp_pns60 tmp_pns600]*1e3,[-2 2]),axis equal,axis off,saveas(gca,[OutDir 'maskc_' num2str(i) '.jpg'])
end

p_nm_s600_mrf = p_nm_s600;
tmp_p = (p_c(:,:,i)-p_c(:,:,1));
tmp_pns600 =(p_nm_s600(:,:,i));
sig = std(tmp_p(mask)-tmp_pns600(mask))

sm = [1e1 0 0 0 1];robust=0;solver='backslash';
for i = 1:60%sz(end)
    tmp_p = 1e3*(p_c(:,:,i)-p_c(:,:,1)).*mask;
    tmp_pns600 = double(1e3*(p_nm_s600(:,:,i)).*mask);
    %tmp_p(:,:,:,i)= T_bcoring2(p_nm_s600(:,:,i),sig,[-1 1],mask);
    p_nm_s600_mrf(:,:,i)= T_mrf(tmp_pns600,mask,robust,solver,sm);
    %imwrite(1e3*[tmp_p tmp_pn tmp_pns],[OutDir 'mask_' num2str(i) '.jpg'])
    imagesc([tmp_p tmp_pns600 p_nm_s600_mrf(:,:,i)],[-2 2]),axis equal,axis off,saveas(gca,[OutDir 'maskc2_' num2str(i) '.jpg'])
end


p_nm_mrf=p_nm;
for i=1:sz(end)
    tmp_p = double(p_nm_s(:,:,i)-p_nm_s(:,:,1));
    sm = [1e-3 0 0 0 1];robust=0;solver='backslash';
    p_nm_mrf(:,:,i)= T_mrf(tmp_p,mask,robust,solver,sm);
end
%}
