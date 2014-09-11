param_init
DD = 'data/';
vids= dir([DD ]);vids(1:2)=[];vids=vids([vids.isdir]);

%num_im0 = @(x) 300;
num_im0=@(x) numel(x);
num_dsp = 30;

num_bit = 12;
up_s = 2^(16-num_bit);
down_s = 2^(num_bit-8);

for aid=1:numel(vids)
    % 10 bit -> 16 bit
    v_name = [DD vids(aid).name '/'];

    if ~exist([v_name(1:end-1) '_dl.mat'],'file')
        im_name = dir([v_name '*.tif']);
        a= imread([v_name im_name(1).name]);
        num_im = num_im0(im_name);
        tmp_vr = zeros([size(a,1) size(a,2) 3 num_im],'uint16');
        parfor i=1:num_im
            tmp_vr(:,:,:,i)= up_s*imread([v_name im_name(i).name]);
        end
        %U_ims2gif(uint8(tmp_vr(:,:,:,1:num_dsp)/down_s),[v_name(1:end-1) '.gif'],0.05)
        save([v_name(1:end-1) '_dl.mat'],'-v7.3','tmp_vr')
        tmp_vr = tmp_vr(:,:,:,1:num_dsp);
        save([v_name(1:end-1) '_ds.mat'],'-v7.3','tmp_vr')
    end
end


