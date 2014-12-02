function out=U_fft(in,dimen,fs,do_plot)
% each column is an observation
N = ndims(in);
 spice = 1:N;
 spice(1) = dimen;
 spice(dimen) = 1;
 in = permute(in, spice);
 in_sz = size(in);
 in = reshape(in, [size(in,1),  numel(in)./size(in,1)]);
 
out = abs(fft(bsxfun(@minus,in,mean(in,1))));
 out = reshape(out, in_sz);
 out = permute(out ,spice);

if ~exist('do_plot','var')
    do_plot=0;
end
if do_plot
sz=size(out);
tmp_x = fs*(1:ceil(sz(end)/2))/sz(end);
cla,hold on
out = out(1:numel(tmp_x));
plot(tmp_x,out),axis([1 max(tmp_x) 0 max(out)])
end
