%%
%param_init
% error averaging for 100Hz
nns={'50_500_b','100_500_b','100_500_s','50_500_s','0_500'};
fprintf('1. load data\n')
nid=2;
nn=nns{nid};
DD = ['data/meta_1010/' nn];

do_light=2;
flo_name = [DD '_cell_ur_f' num2str(do_light) '.mat'];
load(flo_name)
sz =size(flow_l);
num_flo = sz(end);
%%
%{
fprintf('2. band pass video\n')
load([DD '_cell_ur'],'vid');
% looks werid ...
fl=95;fh=105;fs=500;
vid2 = FIRWindowBP(vid, fl/fs,fh/fs);
sz =size(vid);
flow_l = zeros([sz(1:2) 2 sz(3)-1],'single');
vid3=vid2(:,:,2:end);
psz=3;
parfor i = 1:sz(3)-1
    flow_l(:,:,:,i) = T_lk_p3(vid2(:,:,i),vid3(:,:,i),psz);
    %tmp = T_lk_p3(vid2(:,:,i),vid3(:,:,i),psz);
    %flow_l(:,:,:,i) = cat(3,medfilt2(tmp(:,:,1),[3 3]),medfilt2(tmp(:,:,2),[3 3]));
end
%}

%%
fprintf('3. avg over signal \n');
ran_e = {10:20,130:145};
avg_u = mean(reshape(flow_l(ran_e{1},ran_e{2},1,:),[],num_flo));

for k=1:9
    kk = k*3;
    ratio = 5*(kk);
subplot(3,3,k)
signal =reshape(mean(reshape(avg_u(1:floor(num_flo/ratio)*ratio),5,kk,[]),2),1,[]);
plot(signal)
axis([1 numel(signal) -0.2 0.2])
end

