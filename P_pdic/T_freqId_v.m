function [E,freq,amp]=T_freqId_v(tmp_vr,fs,sn,flow_id)
if ~exist(sn,'file')
    if size(tmp_vr,3)==3
        tmp_vr = U_r2g(tmp_vr);
    end
        tmp_vr = squeeze(im2single(tmp_vr));
        sz = size(tmp_vr);
        tmp_flow = zeros([sz(1:2) 2 num_f-1],'single');
        psz=3;
        vid2_tmp= tmp_vr(:,:,2:end);
        parfor j = 1:num_f-1
            tmp_flow(:,:,:,j) = T_lk_p3(tmp_vr(:,:,j), vid2_tmp(:,:,j),psz);
        end
save(sn,'tmp_flow')
else
load(sn,'tmp_flow')
end
tmp_data = squeeze(tmp_flow(:,:,flow_id,:));
tmp_vr2= bsxfun(@minus,tmp_data,mean(tmp_data,3));
tmp_vr3=fft(tmp_vr2,[],3);
num_f = size(tmp_vr,3);
nq_f = floor(num_f/2);
amp =  abs(tmp_vr3(:,:,1:nq_f));
[E,freq]= max(amp,[],3); 
freq = freq/num_f*fs;

%{
figure(1),V_feat(cat(3,E,freq))
figure(2),plot((1:nq_f)/num_f*fs,mean(reshape(amp,[],nq_f),1))
keyboard
%}
