function vid = U_highpass(vid,fcut,fs)

[B,A] = butter(10, (fcut/(fs/2)),'high');

vid = im2double(vid);
for k = 1:size(vid,4);
    vid(:,:,:,k) = rgb2ntsc(vid(:,:,:,k));
end

vid = FiltFiltM(B,A,vid,4);

for k = 1:size(vid,4);
    vid(:,:,:,k) = ntsc2rgb(vid(:,:,:,k));
end

end


%{
sz = size(im);
d= im;
H = fspecial('Gaussian',2*psz_h+1,sigma);
H = H/sum(H(:));
low = convn(padarray(im,[psz_h psz_h],'replicate'),H,'valid');
d= im - low;
%}
%{
parfor i=1:sz(3)
    d(:,:,i) = imfilter(im(:,:,i),H);
end
%}
%{
function d = U_highpass(Fstop,Fpass,Astop,Apass,Fs)
Fstop = 350;
Fpass = 400;
Astop = 65;
Apass = 0.5;
Fs = 1e3;

d = designfilt('highpassfir','StopbandFrequency',Fstop, ...
  'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
  'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','equiripple');
%}
