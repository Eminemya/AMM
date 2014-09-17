param_init

InDir = 'data/';
fid = 1;
c2=[];
fns = {'0Hz_11019fps_0_dl.mat','3100Hz_11019fps_m_dl.mat'};c2=[-5e-3 5e-3];
fns = {'0Hz_11019fps_0_dl.mat','3100Hz_11019fps_s_dl.mat'};c2=[-5e-3 5e-3];
%fns = {'0Hz_11019fps_0_dl.mat','3640Hz_11019fps_m_dl.mat'};c2=[-5e-3 5e-3];
%fns = {'0Hz_11019fps_0_dl.mat','3640Hz_11019fps_s_dl.mat'};
%fns = {'0Hz_11019fps_0_dl.mat','3640Hz_11019fps_l_dl.mat'};
tt=[1 900];
%pts = [128 150]; % center
%pts = [119 184]; % on the side bar
pts = [149 163]; % on the horizontal bar
phase_sc=5;phase_or=1;
%{
fns = {'simu_60000_3000_10_100_600_1_n1.mat'};tt=[1 600];pts=[68,106];
fns = {'simu_60000_3000_10_100_60_1.mat'};tt=[1 60];pts=[68,106];
pts = [19 82];
phase_sc=2;phase_or=1;
%}


%fns=dir('data/*_dl.mat');fns = {fns.name};
%fns = {'0Hz_11019fps_0_dl.mat','0Hz_11019fps_1_dl.mat'};

%

do_step1= 1;
do_step2= 1;
do_step3= 1;
do_step4= 1;
do_step5= 0; % stat visualization
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
        if fns{i}(1)~='s'
            f0s(i) = str2num(fns{i}(find(fns{i}=='_',1,'first')+1:find(fns{i}=='f',1,'first')-1));
            f1s(i) = str2num(fns{i}(1:find(fns{i}=='_',1,'first')-3));
        else
        end
    end
end
if do_step5
    % simulation
    [yy,xx] = meshgrid(1:szs{1}(2),1:szs{1}(1));
    mask = yy>75 & yy<130 & xx>30 & xx<110 & im2double(vid{1}.tmp_vr(:,:,1))>0.5;
    pts = find(mask==1);
end
%f0s(1)=60000;f1s(1)=3000;

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
    if ~isempty(c2)
        axis([0 numel(tmp_p) c2])
    end
    
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
    title('original FFT spectrum'),axis([xx(1) xx(end) 0 4e-3])
    
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
    saveas(gcf,sprintf([fns{1}(1:end-4) '_p_%d_%d_%d_%d.jpg'],pts(1),pts(2),win_sz,fid))
end

if do_step5
    
    
    for i=1%:numel(fns)
        figure(1),clf
        tmp = reshape(pp{i},[],szs{i}(end));
        tmp_p = bsxfun(@minus,tmp(pts_ind{i},:),mean(tmp(pts_ind{i},:),2));
        tmp_p2 = (abs(fft(tmp_p'))).^2/size(tmp_p,2);
        
        % cut off
        tmp_p2(1:ceil(szs{i}(end)*0.01),:)=0;
        tmp_p2(ceil(szs{i}(end)*0.4):end,:)=0;
        tmp_p2 = tmp_p2(1:end/2,:);
        
        xx = f0s(i)/size(tmp_p,2)*(0:(size(tmp_p2,1)-1));
        
        subplot(311),cla,hold on
        plot(xx,median(tmp_p2,2),[cs(i) '-'])
        plot(xx,prctile(tmp_p2',75),[cs(i) '--'])
        plot(xx,prctile(tmp_p2',25),[cs(i) '--'])
        title('FFT spectrum prctile')
        
        % freq
        subplot(3,1,[2 3]),cla,hold on
        tmp_freq = zeros(szs{i}(1:2));
        [~,tmp_freq(pts_ind{i})] = max(tmp_p2,[],1);
        tmp_freq(pts_ind{i}) = xx(tmp_freq(pts_ind{i}));
        imagesc(tmp_freq,[0 f1s*1.5]),colorbar,axis off,axis equal
        
        saveas(gcf,sprintf([fns{1}(1:end-4) '_p_%d_%d_%d_%d_freq.jpg'],pts(1),pts(2),win_sz,fid))
        
        % temporal filtered phase
        figure(2),clf
        tmp_f = reshape(pp_f{i},[],szs{i}(end));
        tmp_fp = bsxfun(@minus,tmp_f(pts_ind{i},:),mean(tmp_f(pts_ind{i},:),2));
        
        tmp_phase = cell(2,2);
        ind = f0s(i)/f1s(i);
        ind = round(1:ind/4:ind);
        for j=1:4
            tmp_phase{j} = zeros(szs{i}(1:2));
            tmp_phase{j}(pts_ind{i}) = tmp_fp(:,ind(j));
            tmp_phase{j} = U_crop(tmp_phase{j});
        end
        ran = prctile(abs(reshape(tmp_fp(:,ind),1,[])),80);
        imagesc(cell2mat(tmp_phase),[-ran ran]),colorbar,axis off,axis equal
        axis equal
        saveas(gcf,sprintf([fns{1}(1:end-4) '_p_%d_%d_%d_%d_phase.jpg'],pts(1),pts(2),win_sz,fid))
    end
    
    
    
end

