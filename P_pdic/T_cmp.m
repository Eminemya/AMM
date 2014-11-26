amps = [10,30,10,60,30,50,10,25,100,25,100];

DD = 'data/neal/';
fns= dir([DD '*.avi']);
do_step1=0;
do_step2=1; psz=5;
do_step3=1;
num_disp = 30;
for i=2:numel(fns)
    fprintf('0. read video\n')
    vid = VideoReader([DD fns(i).name]);
    tmp_vr = im2single(vid.read([1 2]));
    sz = size(tmp_vr);
    flow_l = zeros([sz(1:2) 2 3],'single');
        for fid = 0:3;

        f_pid =0;
        fprintf('2. local flow\n')
        flow_sn = [DD fns(i).name(1:end-4) '_f' num2str(fid) '.mat'];
        switch f_pid
            case 1
                flow_sn =[flow_sn(1:end-4) '_p1.mat'];
        end
            tmp_vr_g = U_r2g(tmp_vr);
            im_ref = tmp_vr_g(:,:,1);
            j=fid+1;
            switc fid
                case 0
                    flow_l(:,:,:,j) = T_lk_p3(im_ref, tmp_vr_g(:,:,2),psz);
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
                        [a,b] = Coarse2FineTwoFrames( ...
                            double(im_ref),double(tmp_vr_g(:,:,2)),para);
                        flow_l(:,:,:,j) = cat(3,a,b);
                case 2
                    % multi-scale+pix
                    do_hs;
                    opts.pyramid_levels=3;
                    opts.max_warping_iters=1;
                    opts.mf=2;
                    opts.fid=1;
                    im_ref = tmp_vr(:,:,:,1);
                    flow_l(:,:,:,j) = T_lk_p_ms2(im_ref, tmp_vr(:,:,:,2),opts);
                 case 3
                    % multi-scale+patch
                    do_hs;
                    opts.max_warping_iters=1;
                    opts.mf=2;
                    opts.fid=2;
                    opts.psz_h=5;
                    opts.step_size=0.1;
                    opts.max_warping_iters=5;
                    im_ref = tmp_vr(:,:,:,1);
                    flow_l(:,:,:,j) = T_lk_p_ms2(im_ref, tmp_vr(:,:,:,2),opts);
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

        end
        
      % V_feat(reshape(flow_l,sz(1),sz(2),[]),[],[],[-4 4]) 
end
