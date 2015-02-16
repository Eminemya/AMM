rmpath(genpath([LLIB 'MotionHDR/Code/matlab/MatlabTools/thirdparty/OpticalFlowCe/mex']))
addpath(genpath([DLIB 'Low/Flow/CeOF/']))

DD0 = 'data/meta_0721/';
vname = 'wn_1000fps_ex_990us_l.avi';fs = 1000;
%vname = 'wn_1000fps_ex_990us_s.avi';fs = 1000;
%vname = '/data/vision/billf/auto-mm/0916/data/struct_0721/wn_1000fps_ex_990us_l.avi';fs = 1000;
do_step1=0;
do_step2=0;
do_step3=1;
do_step4=1;

if do_step1
    vid = VideoReader([DD0 vname]);
    nF = inf;
    tmp_vr0 = vid.read([1,nF]);
    nF = size(tmp_vr0,4);
    nq_f = floor(nF/2);
    plot_xx = (1:nq_f)/nF*fs;
end

if do_step2
    fprintf('2. Intensity-basaed FreqId\n')
    tmp_vr = repmat(tmp_vr0,[1 1 3 1]);
    tmp_vr = U_remove120(tmp_vr,115,125,fs);
    tmp_vr = U_remove120(tmp_vr,235,245,fs);
    tmp_vr = U_remove120(tmp_vr,355,365,fs);
    
    [E,freq,amp]=T_freqId(tmp_vr,fs);
    amp_2 = reshape(amp,[],nq_f);
    figure(1),V_feat(cat(3,E,freq))
    figure(2),subplot(221),plot(plot_xx,mean(amp_2,1))
    E_id = E>=prctile(E(:),80);
    figure(2),subplot(222),imagesc(E_id)
    amp_3 = amp_2(E_id(:),:);
    figure(2),subplot(223),plot((1:nq_f)/nF*fs,mean(amp_3,1))
    figure(2),subplot(224),imagesc(E_id.*freq)
    
    imwrite(U_g2rw(E_id.*freq/50),'wn_freq_map.png')
    figure(2),clf,plot((1:nq_f)/nF*fs,mean(amp_3,1))
    saveas(gcf,'wn_freq_E.png')
end

if do_step3
    fprintf('3. estimate motion\n')
    if ~exist([vname(1:end-4) '_f.mat'],'file');
        tmp_f = U_of(squeeze(tmp_vr0));
        save([vname(1:end-4) '_f.mat'],'tmp_f');
        %v_flo= V_flo(tmp_f,0.2,50,50);
        %U_ims2gif(uint8(v_flo),[vname(1:end-4) '_vf.gif'],0,100/fs);
    else
        load([vname(1:end-4) '_f.mat']);
    end    
end


if do_step4
    fprintf('4. Motion-basaed FreqId\n')
    nq_f = floor((nF-1)/2);
    plot_xx = (1:nq_f)/(nF-1)*fs;
    
    [E,freq,amp]=T_freqId(squeeze(sum(tmp_f.^2,3)),fs);
    amp_2 = reshape(amp,[],nq_f);
    %figure(1),V_feat(cat(3,E,freq))
    imwrite(U_g2rw(E),[vname(1:end-4) 'tmaxE.png'])
    imwrite(U_g2rw(freq,250,0),[vname(1:end-4) 'tmaxF.png'])
    
    figure(2),clf,plot(plot_xx,mean(amp_2,1))
    [a,b]=findpeaks(double(mean(amp_2,1)),'MinPeakHeight',0.2);
    hold on,plot(plot_xx(b),a,'rx')
    saveas(gcf,[vname(1:end-4) 'tmaxF1.png'])
    %{
    E_id = E>=prctile(E(:),80);
    figure(2),subplot(222),imagesc(E_id)
    amp_3 = amp_2(E_id(:),:);
    figure(2),subplot(223),plot((1:nq_f)/nF*fs,mean(amp_3,1))
    figure(2),subplot(224),imagesc(E_id.*freq)
    %}
    %imwrite(U_g2rw(E_id.*freq/50),'wn_freq_map.png')
    %figure(2),clf,plot((1:nq_f)/nF*fs,mean(amp_3,1))
    %saveas(gcf,'wn_freq_E.png')
    
end
if do_step5
    %%
    %clf, imagesc(tmp_vr0(:,:,:,1))
    % transmission analysis
    %patches = {{190:340,20:150},{150:200,880:1010}};
    %patches = {{150:190,950:1000},{150:190,1:50}};
    patches = {{190:340,888:1018},{190:340,20:150}};
    %patches = {{225:285,918:988},{225:285,50:120}};
    nq_f = floor((nF-1)/2);
    plot_xx = (1:nq_f)/(nF-1)*fs;
    
    
    figure(2),V_feat({tmp_vr0(patches{1}{1},patches{1}{2},:,1), ...
        tmp_vr0(patches{2}{1},patches{2}{2},:,1)})
    %
    fft_p=cell(1,2);
    tmp_fE= squeeze(sum(tmp_f.^2,3));
    for i=1:2
        %fft_p{i} = U_fft(reshape(tmp_vr(patches{i}{1},patches{i}{2},:),[],nF)');
        fft_p{i} = U_fft(reshape(tmp_fE(patches{i}{1},patches{i}{2},:),[],nF-1)',1);
    end
    
    figure(3),subplot(221),plot(plot_xx,mean(fft_p{1}(1:nq_f,:),2)),axis([plot_xx([1 end]) 0 0.4]),title('Input PSD')
    figure(3),subplot(222),plot(plot_xx,mean(fft_p{2}(1:nq_f,:),2)),axis([plot_xx([1 end]) 0 0.4]),title('Output PSD')
    figure(3),subplot(223),plot(plot_xx,mean(fft_p{2}(1:nq_f,:),2)./mean(fft_p{1}(1:nq_f,:),2)),title('Transmission Rate')
    
    saveas(gcf,[vname(1:end-4) 'trans.png'])
end
