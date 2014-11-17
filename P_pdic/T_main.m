param_init
DD = 'data/neal/';
fns= dir([DD '*.avi']);
fss =[30 30 300 300 1500 24 1900 600 10000 200 5600];
fls = [10,10,1,36,78,0.2,74,72,10,9,340];
fhs = [14,14,8,62,82,0.4,78,92,20,15,370];
amps = [10,30,10,60,30,50,10,25,100,25,100];
do_step1=0;
do_step2=1; psz=5;
do_step3=1;
num_disp = 30;
for i=1:numel(fns)
    fprintf('0. read video\n')
    vid = VideoReader([DD fns(i).name]);
    tmp_vr = im2single(vid.read());
    sz = size(tmp_vr);
    if do_step1
        fprintf('1. find frequency\n')
        T_freqId(tmp_vr);
    end
    if do_step2
        fid = 0;
        f_pid =0;
        fprintf('2. local flow\n')
        flow_sn = [DD fns(i).name(1:end-4) '_f' num2str(fid) '.mat'];
        switch f_pid
            case 1
                flow_sn =[flow_sn(1:end-4) '_p1.mat'];
        end
        if ~exist(flow_sn,'file')
            flow_l = zeros([sz(1:2) 2 sz(end)-1],'single');
            tmp_vr_g = U_r2g(tmp_vr);
            im_ref = tmp_vr_g(:,:,1);
            switch fid
                case 0
                    parfor j = 1:sz(end)-1
                        flow_l(:,:,:,j) = T_lk_p3(im_ref, tmp_vr_g(:,:,j+1),psz);
                    end
                case 1
                    % too long
                    addpath(genpath([DLIB 'Low/Flow/CeOF/']))
                    alpha = 0.05;
                    ratio = 0.5;
                    minWidth = 100;
                    nOuterFPIterations = 7;
                    nInnerFPIterations = 1;
                    nSORIterations = 30;
                    para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
                    parfor j = 1:sz(end)-1
                        [a,b] = Coarse2FineTwoFrames( ...
                            double(im_ref),double(tmp_vr_g(:,:,j+1)),para);
                        flow_l(:,:,:,j) = cat(3,a,b);
                    end
                case 2
                    % multi-scale
                    do_hs;
                    opts.pyramid_levels=3;
                    opts.max_warping_iters=1;
                    opts.mf=2;
                    opts.fid=1;
                    im_ref = tmp_vr(:,:,:,1);
                    parfor j = 1:sz(end)-1
                        flow_l(:,:,:,j) = T_lk_p_ms2(im_ref, tmp_vr(:,:,:,j+1),opts);
                    end
            end
            switch f_pid
                case 1
                    % band pass
                    flow_l(:,:,1,:) = FIRWindowBP(squeeze(flow_l(:,:,1,:)),fls(i)/fss(i),fhs(i)/fss(i));
                    flow_l(:,:,2,:) = FIRWindowBP(squeeze(flow_l(:,:,2,:)),fls(i)/fss(i),fhs(i)/fss(i));
                    %{
                    % check amplitude
                    tmp_f = reshape(flow_l(:,:,1,:),[],sz(4)-1);
                    out = abs(fft(bsxfun(@minus,tmp_f,mean(tmp_f,2)),[],2));
                    [amp,freq]=max(out,[],2); % noise energy dominant
                    V_feat(cat(3,reshape(amp,sz(1:2)),reshape(freq,sz(1:2))))
                    amp2 = reshape(sum(out(:,fls(i):fhs(i)),2),sz(1:2));
                    imagesc(amp2)
                    %}
            end
            save(flow_sn,'flow_l')
        else
            load(flow_sn,'flow_l')
        end
        
        if ~exist([flow_sn(1:end-3) 'gif'],'file')
            sz2= size(flow_l);sz2(4) = num_disp;
            flow_l_v = zeros([sz2(1:2) 3 sz2(4)],'uint8');
            parfor j =1:sz2(4)
                flow_l_v(:,:,:,j) = flowToColor(flow_l(:,:,:,j));
            end
            U_ims2gif(flow_l_v,[flow_sn(1:end-3) 'gif'],0,1/24);
        end
    else
        load(flow_sn,'flow_l')
    end
    
    if do_step3
        fprintf('3. motion amplification\n')
        amp_sn = [DD fns(i).name(1:end-4) '_lag' num2str(fid) '.mat'];
        if ~exist(amp_sn,'file')
            amp = amps(i);
            tmp_vr2 = uint8(255*tmp_vr);
            tmp_ref =  tmp_vr2(:,:,:,1);
            parfor j=2:sz(end)
                tmp_f = flow_l(:,:,:,j-1);
                tmp_vr2(:,:,:,j) = warpImage2(tmp_ref,amp*tmp_f(:,:,1),amp*tmp_f(:,:,2));
            end
            save(amp_sn,'tmp_vr2')
        else
            load(amp_sn,'tmp_vr2')
        end
        if ~exist([amp_sn(1:end-3) 'gif'],'file')
            %U_ims2gif(tmp_vr2,sprintf('lag_meta_%d_%d_%d.gif',nid,amp,fs(nid)),0,0.03)
            %U_ims2gif(tmp_vr2,[amp_sn(1:end-3) 'gif'],0,1/fss(i));
            U_ims2gif(tmp_vr2(:,:,:,1:num_disp),[amp_sn(1:end-3) 'gif'],0,1/24);
        end
    end
end
