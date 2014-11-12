fprintf('1. get data\n')
do_save = 1;

nns={'50_500_b','100_500_b','100_500_s','50_500_s','0_500'};
f0=500;
%{
do_save=1;do_step1=1;do_step2=0;
for nid=1:5
    D1_lag1010
end

% remove light
%}
nn = nns{nid};
DD = ['data/meta_1010/' nn];
load([DD '_cell_ur'],'vid2');vid=vid2;

% only the vibration
vid = vid(:,:,end-1000:end);

sz =size(vid);

fprintf('2. lighting effects\n')
avg_i =  mean(reshape(vid,[],sz(3)),1);

addpath('../0916/MotionHDR/Code/matlab/MatlabTools/Tools/')
vid_0 = reshape(vid,[sz(1:2) 1 sz(3)]);
vid2_0 = U_remove120(cat(3,vid_0,vid_0,vid_0),115,125,f0);
vid2_1 = U_remove120(vid2_0,235,245,f0);


%vid2  = squeeze(vid2_0(:,:,1,:));
vid2  = squeeze(vid2_1(:,:,1,:));
avg_i2 =  mean(reshape(vid2,[],sz(3)),1);

clf
subplot(221),cla
imagesc(vid(:,:,1))
title('a patch')

subplot(222)
cla,hold on,
ran = (1:100);
%ran = 1000+(1:100);

plot(avg_i2(ran),'r-')
plot(avg_i(ran),'b-')
xlabel('Frames')
ylabel('Average Intensity')

tmp_x = 500*(1:ceil(sz(3)/2))/sz(3);
subplot(223),cla,hold on
tmp_f=abs(fft(avg_i-mean(avg_i)));
plot(tmp_x,tmp_f(1:numel(tmp_x))),axis([1 max(tmp_x) 0 0.1])
[aa,bb]=findpeaks(double(tmp_f(1:numel(tmp_x))),'Threshold',1.5e-2);
plot(bb/sz(3)*500,aa,'rx')
xlabel('Freq')
ylabel('Power Spectrum')
title('original video')

subplot(224),cla,hold on
tmp_f2=abs(fft(avg_i2-mean(avg_i2)));
plot(tmp_x,tmp_f2(1:numel(tmp_x))),axis([1 max(tmp_x) 0 0.1])
[aa,bb]=findpeaks(double(tmp_f2(1:numel(tmp_x))),'Threshold',1e-2);
plot(bb/sz(3)*500,aa,'rx')
xlabel('Freq')
ylabel('Power Spectrum')
title('120Hz light removal video')

if do_save
    saveas(gca,['../meta_' nn '.png'])
    %save(['dl_' nn],'vid2')
end
end