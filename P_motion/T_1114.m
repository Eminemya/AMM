if ~exist('done_init','var')
    param_init
end
%%
do_disp=0;
fprintf('Pipeline for motion comparison \n');
% 1114
DD='data/data_1114/';
aid=1;
did=4;
switch did
    case 1
        sid = 's';nn = sprintf('50Hz_500fps_%s',sid);m2_ran ={14:17,11:14};
    case 2
        sid = 's';nn = sprintf('100Hz_500fps_%s',sid);m2_ran ={14:17,11:14};
    case 3
        sid = 't';nn = sprintf('50Hz_500fps_%s',sid);m2_ran ={14:17,11:14};
    case 4
        sid = 't';nn = sprintf('100Hz_500fps_%s',sid);m2_ran ={14:17,11:14};
    case 5
        sid = 'f';nn = sprintf('50Hz_500fps_%s',sid);m2_ran ={14:17,11:14};
    case 6
        sid = 'f';nn = sprintf('100Hz_500fps_%s',sid);m2_ran ={14:17,11:14};
end

sn =[DD 'xlsx/' nn '.xlsx']; % sensor measurement file
switch sid
    case 's'
        % steady state
        num_f = 600;
    case 't'
        % transient state
        num_f = 2000;
    case 'f'
        % transient state
        num_f = 3000;
end
DD = [DD nn '/'];

f0 = 500;
fs = str2num(nn(1:find(nn=='H',1,'first')-1));
% output+5.tif for 12 bit images
fns = dir([DD '/*.tif']);
num_f = min(num_f,numel(fns));
tmp_im = im2single(imread(fullfile(DD,fns(1).name)));
sz = size(tmp_im);
if do_disp && 0
    %%
    figure(1),clf
    imagesc(tmp_im)
end

fprintf('1. get cropped region \n');

% middle+upper-right
crop ={{205:230,302:327}};

num_crop = numel(crop);
sz_crop = cell(1,num_crop);
mask_crop = cell(1,num_crop);
mask_crop2 = cell(1,num_crop);
for i=1:num_crop
    sz_crop{i} = [numel(crop{i}{1}) numel(crop{i}{2})];
    [yy,xx]=meshgrid(1:sz_crop{i}(2),1:sz_crop{i}(1));
    % imagesc(-xx+1*yy<=-18)
    mask_crop{i} = tmp_im(crop{i}{1},crop{i}{2})>0.3 & tmp_im(crop{i}{1},crop{i}{2})<0.6;
    mask_crop{i} = double(mask_crop{i}&(-xx+1*yy>-18));
    mask_crop{i}(mask_crop{i}==0) = nan;
    mask_crop2{i} = nan(sz_crop{i});
end

mask_crop2{1}(m2_ran{1},m2_ran{2})=1;

if do_disp
    %%
    % at most 3 acc
    figure(2)
    for i=1:num_crop
        subplot(num_crop,3,i*3-2),imagesc(tmp_im(crop{i}{1},crop{i}{2})),axis equal
        subplot(num_crop,3,i*3-1),imagesc(mask_crop{i}),axis equal
        subplot(num_crop,3,i*3),imagesc(double(~isnan(mask_crop{i}))+double(~isnan(mask_crop2{i}))),axis equal
        %{
        subplot(num_crop,1,i),
        imshow(tmp_im(crop{i}{1},crop{i}{2})),hold on
        plot(1:size(xx,2),(1:size(xx,2))*1+8,'r-')
        
        %}
    end
end


%%
fprintf('2. read video \n');
vn = [DD(1:end-1) '_vid1.mat'];
if ~exist(vn,'file')
    vid1=[];vid2=[];vid3=[];
    for i=1:num_crop
        eval(['vid' num2str(i) ' = zeros([sz_crop{i} 1 num_f],''single'');']);
    end
    parfor i =1:num_f
        tmp = im_amp*im2single(imread(fullfile(DD, fns(i).name)));
        vid1(:,:,1,i) = tmp(crop{1}{1},crop{1}{2});
        if(num_crop>1)
            vid2(:,:,1,i) = tmp(crop{2}{1},crop{2}{2});
            if(num_crop>2)
                vid3(:,:,1,i) = tmp(crop{3}{1},crop{3}{2});
            end
        end
    end
    vid_orig ={vid1,vid2,vid3};
    
    % high pass
    for i=1:num_crop
        eval(['tmp_vid= repmat(vid' num2str(i) ',[1,1,3,1]);']);
        %tmp_vid = U_highpass(tmp_vid,10,f0);
        tmp_vid = U_highpass2(tmp_vid,7,4);
        vid{i} = squeeze(tmp_vid(:,:,1,:));
        % equalize light
        %tmp_vid =squeeze(tmp_vid(:,:,1,:));vid{i} = bsxfun(@minus,tmp_vid,mean(mean(tmp_vid,1),2))+mean(tmp_vid(:));
    end
    %{%}
    save(vn,'vid','vid_orig')
else
    load(vn,'vid','vid_orig')
end

fprintf('2.5. double check: lighting app\n');
do_checklight=1;
if do_checklight && do_disp
    %%
    ff= @(x) set(x,'FontSize',20,'axis','tight');
    for i=1:num_crop
        figure(i),clf
        signal = mean(reshape(vid_orig{i},[],num_f));
        signal2 = mean(reshape(vid{i},[],num_f));
        subplot(221),plot(signal),set(gca,'FontSize',20),axis tight,title('original: avg intensity')
        subplot(222),tmp=U_fft(signal,2,f0,1);[~,a]=max(tmp);a/num_f*f0;set(gca,'FontSize',20),axis tight,title('original: PSD'),
        if sid=='s'
            %[~,loc]=findpeaks(double(tmp),'MinPeakHeight',0.05);loc/num_f*f0
            subplot(223),plot(signal2),set(gca,'FontSize',20),axis tight,title('remove low freq: avg intensity')
            subplot(224),tmp=U_fft(signal2,2,f0,1);[~,a]=max(tmp);a/num_f*f0;set(gca,'FontSize',20),axis tight,title('remove low freq: PSD')
        end
    end
    saveas(gcf,[DD(1:end-1) '_light.png'])
end

%%
fprintf('4. motion from video \n');
if ~exist([DD(1:end-1)  '_vid_f.mat'],'file')
    flow_l = cell(1,num_crop);
    for i=1:num_crop
        fprintf('crop: %d\n',i)
        tmp_flow = zeros([sz_crop{i} 2 num_f-1],'single');
        psz=3;
        switch sid
            case 's'
                vid2 = vid{i};
            case {'t','f'}
                vid2 = vid_orig{i};
        end
        
        vid2_tmp= vid2(:,:,2:end);
        parfor j = 1:num_f-1
            tmp_flow(:,:,:,j) = T_lk_p3(vid2(:,:,j), vid2_tmp(:,:,j),psz);
        end
        flow_l{i} = tmp_flow;
    end
    save([DD(1:end-1) '_vid_f.mat'],'flow_l')
else
    load([DD(1:end-1) '_vid_f.mat'],'flow_l')
end

%bandpass
flow_l0=flow_l;

for i=1:num_crop
    for k=1:2
        flow_l{i}(:,:,k,:) = TTFilterButter(squeeze(flow_l0{i}(:,:,k,:)),fs-5,fs+5,f0);
        signal = mean(reshape(flow_l{i}(:,:,k,:),[],num_f-1));
        signal2 = mean(reshape(flow_l0{i}(:,:,k,:),[],num_f-1));
        tmp= U_fft(signal,2,f0);
        tmp2= U_fft(signal2,2,f0);
        %flow_l{i}(:,:,k,:) = flow_l{i}(:,:,k,:)*max(tmp2)/max(tmp);
        flow_l{i}(:,:,k,:) = flow_l{i}(:,:,k,:)*mean(abs(signal2))/mean(abs(signal));
    end
end
clf,hold on
signal = mean(reshape(flow_l{i}(:,:,k,:),[],num_f-1));
signal2 = mean(reshape(flow_l0{i}(:,:,k,:),[],num_f-1));
plot(signal,'b-')
plot(signal2,'r-')

%{%}
%%
fprintf('4.5. double check: motion freq\n');
do_checkmotion=1;
do_checkmotion2=1;
if do_checkmotion && do_disp
    %%
    for i=1:num_crop
        figure(i)
        signal = mean(reshape(flow_l{i}(:,:,1,:),[],num_f-1));
        signal2 = mean(reshape(flow_l{i}(:,:,2,:),[],num_f-1));
        subplot(221),plot(signal)
        subplot(222),tmp=U_fft(signal,2,f0,1);[~,a]=max(tmp);a/num_f*f0
        %[~,loc]=findpeaks(double(tmp),'MinPeakHeight',1);loc/num_f*f0
        subplot(223),plot(signal2)
        subplot(224),tmp=U_fft(signal2,2,f0,1);[~,a]=max(tmp);a/num_f*f0
    end
    
end
fprintf('4.6. double check: motion shape\n');
if do_checkmotion2 && do_disp
    %%
    frame_id = 105;
    for i=1:num_crop
        figure(i),clf
        subplot(321),imagesc(flow_l{i}(:,:,1,frame_id));
        subplot(322),imagesc(flow_l{i}(:,:,2,frame_id));
        subplot(323),imagesc(flow_l{i}(:,:,1,frame_id).*mask_crop{i});
        subplot(324),imagesc(flow_l{i}(:,:,2,frame_id).*mask_crop{i});
        subplot(325),imagesc(flow_l{i}(:,:,1,frame_id).*mask_crop2{i});
        subplot(326),imagesc(flow_l{i}(:,:,2,frame_id).*mask_crop2{i});
    end
end

%%
fprintf('5. motion from censor \n');
if (sid =='f')
    flow_s={load([sn(1:end-4) 'txt'])};
    flow_s{1}=flow_s{1}(:,[1 2]);
else
flow_s = U_readxls(sn,1);
end
fprintf('5.5. double check: sensor\n');
do_checksensor=0;
ran = 1200:6500;
%ran = 1:size(flow_s{flow_sid},1);
f0=2049;
if do_checksensor && do_disp
    %%
    figure(1)
    cc=1;
    for i=[1]
        signal = reshape(flow_s{i}(ran,2),[],numel(ran));
        subplot(2,2,cc*2-1),plot(signal)
        subplot(2,2,cc*2),tmp=U_fft(signal,2,f0,1);[~,a]=max(tmp);a/num_f*f0
        %[~,loc]=findpeaks(double(tmp),'MinPeakHeight',0.05);loc/num_f*f0
        cc=cc+1;
    end
end
%{
clf
 rr = 100:8000;
 plot(flow_s{1}(rr,1),flow_s{1}(rr,2))
rr2= 1:size(flow_l{1},4);
plot(squeeze(flow_l{1}(14,15,1,rr2)))
%}
%%
fprintf('6. motion comparison \n');
match = [2 1 3];
len_real = 317;
len_pix = 1010;
flow_sid = 1;
%motion_sc = len_real/len_pix/9.8*100;
motion_sc = 16; % without temporal bandpass
%motion_sc = 20;
ran = {1:num_f-1,1:size(flow_s{flow_sid},1)};
%ran = {202:445,500:1500};mid=3;Gfilt = exp(-(-2:2).^2/2);% 50Hz_500fps_a1_s
%ran = {202:445,509:1500};mid=3;Gfilt = exp(-(-2:2).^2/2);% 50Hz_500fps_a2_s
%ran = {202:445,503:1500};mid=3;Gfilt = exp(-(-2:2).^2/2);% 50Hz_500fps_a3_s
%ran = {202:445,488:1500};mid=3;Gfilt = exp(-(-2:2).^2/2);% 50Hz_500fps_a4_s
%ran = {1:num_f-1,1200:2500};
%ran = {201:345,498:1100};mid=3;Gfilt = exp(-(-2:2).^2/3);% 100Hz_500fps_a1_s
%ran = {700:1000,1250:2500};mid=3;Gfilt = exp(-(-2:2).^2/2);% 100Hz_500fps_a1_t
%ran = {201:345,509:1100};mid=3;Gfilt = exp(-(-2:2).^2/3);% 100Hz_500fps_a2_s

switch did
    case 1
        ran = {201:345,375:14500};mid=3;Gfilt = exp(-(-2:2).^2/3);
    case 2
        ran = {201:345,420:14500};mid=3;Gfilt = exp(-(-2:2).^2/3);
    case 3
        ran = {697:900,49020:70000};mid=3;Gfilt = exp(-(-2:2).^2/2);
    case 4
        ran = {750:900,53370:68000};mid=3;Gfilt = exp(-(-2:2).^2/2.9);% 100Hz_500fps_a4_s
    case 5
        ran = {100:1600,960:8000};mid=3;Gfilt = exp(-(-2:2).^2/1);% 100Hz_500fps_a4_s
        %ran = {100:500,960:2600};mid=3;Gfilt = exp(-(-2:2).^2/2);% 100Hz_500fps_a4_s
end
%ran = {151:295,390:1500};mid=3;Gfilt = 1;% 100Hz_500fps_a4_s
filt_offset = 5;
% angle
acc_angle = pi/4;
%m2 = @(x,y) nanmean(reshape(bsxfun(@times,squeeze(x),y),[],numel(ran{1})),1);
Gfilt = Gfilt/sum(Gfilt);
%Gfilt=0.4;
m2 = @(x,y) conv(conv(nanmedian(reshape(bsxfun(@times,squeeze(x),y),[],numel(ran{1})),1),Gfilt ,'same'),[1 -2 1],'same');
f0 =500;
for i=1:num_crop
    subplot(num_crop,1,i),cla,hold on
    %imagesc(flow_l{i}(:,:,1,1))
    switch mid
        case 1
            tmp_fu = m2(flow_l{i}(:,:,1,ran{1}),mask_crop2{i});
            tmp_fv = m2(flow_l{i}(:,:,2,ran{1}),mask_crop2{i});
        case 2
            tmp_fu = m2(flow_l{i}(:,:,1,ran{1}),mask_crop{i});
            tmp_fv = m2(flow_l{i}(:,:,2,ran{1}),mask_crop{i});
        case 3
            tmp_fu = m2(flow_l{i}(:,:,1,ran{1}),ones(size(mask_crop{i})));
            tmp_fv = m2(flow_l{i}(:,:,2,ran{1}),ones(size(mask_crop{i})));
    end
    switch aid
        case {1,3,4}
            tmp_f = cos(acc_angle)*tmp_fu -sin(acc_angle)*tmp_fv;
        case 2
            switch i
                case 1
                    tmp_f = -cos(acc_angle)*tmp_fu +sin(acc_angle)*tmp_fv;
                case 2
                    tmp_f = cos(acc_angle)*tmp_fu +sin(acc_angle)*tmp_fv;
            end
    end
    x2 = (ran{1}(filt_offset:end-filt_offset+1)-ran{1}(filt_offset))/f0;
    s2 = motion_sc*tmp_f(filt_offset:end-filt_offset+1);
    plot(x2,s2,'b-','LineWidth',2)
    
    %motion_sc =23;plot((ran{1}-ran{1}(1))/f0,mean(reshape(bsxfun(@times,flow_l{i}(:,:,1,ran{1}),mask_crop{i}),[],numel(ran{1})),1)*motion_sc,'b-')
    %motion_sc =5;plot((ran{1}-ran{1}(1))/f0,mean(reshape(flow_l{i}(:,:,1,ran{1}),[],numel(ran{1})),1)*motion_sc,'b-')
    
    x1 = flow_s{flow_sid}(ran{2},1)-flow_s{flow_sid}(ran{2}(1),1);
    s1 = flow_s{flow_sid}(ran{2},2);
    plot(x1,-0+s1,'r-','LineWidth',2)
    
    
    
    set(gca,'FontSize',20)
    title(sprintf('relative error %.2f%%',U_err(x1,s1,x2,s2,4)*100))
    xlabel('Time (s)')
    ylabel('Acceleration (g)')
    legend('camera measurement','accelerameter measurement','Location','best')
    %axis tight
    axis([x1(1) x1(end) min(s1)*2 max(s1)])
end

%saveas(gcf,[DD(1:end-1) '_sensor.png'])
