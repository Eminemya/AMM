vname = '/data/vision/billf/auto-mm/0916/data/struct_0721/wn_1000fps_ex_990us_l.avi';fs = 1000;
vname = '/data/vision/billf/auto-mm/0916/data/struct_0721/wn_1000fps_ex_990us_l.avi';fs = 1000;
do_step1=0;
do_step2=0;
do_step3=0;

if do_step1
vid = VideoReader(vname);
nF = inf;
tmp_vr0 = vid.read([1,nF]);
nF = size(tmp_vr0,4);
nq_f = floor(nF/2);
plot_xx = (1:nq_f)/nF*fs;
end

if do_step2
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
% transmission analysis
patches = {{190:340,20:150},{150:200,880:1010}};
%patches = {{150:200,1:50},{150:200,950:1000}};
fft_p=cell(1,2);
for i=1:2
    fft_p{i} = U_fft(reshape(tmp_vr(patches{i}{1},patches{i}{2},:),[],nF)');
end
figure(3),subplot(221),plot(plot_xx,mean(fft_p{1}(1:nq_f,:),2))
figure(3),subplot(222),plot(plot_xx,mean(fft_p{2}(1:nq_f,:),2))
figure(3),subplot(223),plot(plot_xx,mean(fft_p{2}(1:nq_f,:),2)./mean(fft_p{1}(1:nq_f,:),2))

end
