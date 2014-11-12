nns={'50_500_b','100_500_b','50_500_s','100_500_s','0_500'};
fprintf('Lag mo-mag\n')
do_pre=0;
f0=500;
%{
% remove light
addpath('../0916/MotionHDR/Code/matlab/MatlabTools/Tools/')
addpath('Theo/')
do_save=1;do_step1=1;do_step2=0;
for nid=1:5
    D3_lag1010
end

% remove light
%}
if do_step1
    %%
    fprintf('1. flow computation\n')
    nn = nns{nid};
    DD = ['data/meta_1010/' nn];
    fns = dir([DD '/*.tif']);
    f0=500;
    ran=1000:1049;
    num_f = numel(ran);
    %sz = size(imread(fullfile(DD,fns(1).name)));
    load([DD '_ran'],'vid2')
    
    sz = size(vid);
    if exist(['D3_' nn '.mat'],'file')
        load(['D3_' nn],'flow_l')
    else
        fprintf('1.3 LK\n')
        flow_l = zeros([sz(1:2) 2 num_f-1],'single');
        psz=3;
        vid2_tmp= vid2(:,:,2:end);
        parfor i = 1:num_f-1
            flow_l(:,:,:,i) = T_lk_p3(vid2(:,:,i), vid2_tmp(:,:,i),psz);
        end
        
        save(['D3_' nn],'flow_l')
    end
    fns1=fns(ran);
    
    if do_save
        U_ims2gif([squeeze(vid(:,:,:,1:20)),vid2(:,:,1:20)],['dl60_' nn '.gif'])
        %{
    fr=10;
    tmp_dir= 'tmp2/';mkdir(tmp_dir)
    try;delete([tmp_dir '/*']);end
    parfor i=1:num_f;imwrite(squeeze(uint8(vid(:,:,1,i)*255)),[tmp_dir fns1(i).name]);end
    U_fns2avi2(tmp_dir,fns1,['orig_' nn '.avi'],fr,255)
    tmp_dir= 'tmp2/';mkdir(tmp_dir)
    try;delete([tmp_dir '/*']);end
    parfor i=1:num_f;imwrite(uint8(vid2(:,:,i)*255),[tmp_dir fns1(i).name]);end
    U_fns2avi2(tmp_dir,fns1,['dl_' nn '.avi'],fr,255)
        %}
    end
end
if do_step2
    %%
    fprintf('2. interpolation')
    tmp_dir= 'tmp2/';mkdir(tmp_dir)
    try;delete([tmp_dir '/*']);end
    tmp_vr2 = uint8(amp*im2single(imread(fullfile(DD,fns1(i).name))));
    parfor i=2:sz(end)
        tmp_vr2(:,:,i) = warpImage2(tmp_vr(:,:,1),amp*flo(:,:,1,i-1),amp*flo(:,:,2,i-1));
    end
end