function out=U_fft(in,fs)
out = abs(fft(bsxfun(@minus,in,mean(in))));
sz=size(out);
tmp_x = fs*(1:ceil(sz(end)/2))/sz(end);
cla,hold on
out = out(1:numel(tmp_x));
plot(tmp_x,out),axis([1 max(tmp_x) 0 max(out)])
