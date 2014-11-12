nns={'50_500_b','100_500_b','100_500_s','50_500_s','0_500'};
fprintf('Lag mo-mag\n')
do_step1=1;
do_step2=0;
f0=500;
addpath('../0916/MotionHDR/Code/matlab/MatlabTools/Tools/')
addpath('Theo/')

if do_step1
    %%    
    % upper corner cell
    for nid=1:3%numel(nns)
        nn = nns{nid};
        DD = ['data/meta_1010/' nn];
        fns = dir([DD '/*.tif']);
        
        num_f = min(3000,numel(fns));
        
        sz = size(imread(fullfile(DD,fns(1).name)));
        ind = {1:150,850:1024};
        fprintf('0. pre mat\n')
        vid = zeros([sz(1:2) 1 num_f],'single');
        amp=16;                
        vid =zeros([numel(ind{1}),numel(ind{2}) 1 num_f],'single');
        parfor i =1:num_f
            tmp = im2single(imread(fullfile(DD, fns(i).name)));
            vid(:,:,1,i) = amp*tmp(ind{1},ind{2});
        end
        
        vid1 = U_remove120(cat(3,vid,vid,vid),115,125,f0);
        vid2 = U_remove120(vid1,235,245,f0);
        vid2 = squeeze(vid2(:,:,1,:));  
        vid= squeeze(vid);
        save([DD '_cell_ur'],'-v7.3','vid','vid2')
    end
end


if do_step2
    %%
    % center frames
    for nid=1:numel(nns)
        nn = nns{nid};
        DD = ['data/meta_1010/' nn];
        fns = dir([DD '/*.tif']);
        
        ran=1000:1049;
        num_f = numel(ran);
        sz = size(imread(fullfile(DD,fns(1).name)));
        
        fprintf('0. pre mat\n')
        vid = zeros([sz(1:2) 1 num_f],'single');
        amp=16;
        fns1=fns(ran);
        parfor i = 1:num_f
            vid(:,:,1,i) = amp*im2single(imread(fullfile(DD,fns1(i).name)));
        end
        vid1 = U_remove120(cat(3,vid,vid,vid),115,125,f0);
        vid2 = U_remove120(vid1,235,245,f0);
        vid2 = squeeze(vid2(:,:,1,:));
        vid = squeeze(vid);
        save([DD '_cell_all'],'-v7.3','vid','vid2')
    end
end

if do_step3
    %%
    % additional light filtering
    sufs={'all','ur'};
    for suf_id= 1:numel(sufs)
        suf=sufs{suf_id};
    for nid=1:numel(nns)
        nn = nns{nid};
        DD = ['data/meta_1010/' nn];
        load([DD '_cell_' suf],'vid2','vid')
        sz =size(vid2);
        vid3 = reshape(vid2,sz(1),sz(2),1,[]);
        vid3 = U_remove120(cat(3,vid3,vid3,vid3),55,65,f0);
        vid3 = U_remove120(vid3,135,145,f0);
        vid3 = squeeze(vid3(:,:,1,:));        
        save([DD '_cell_' suf],'vid','vid2','vid3')
    end
end