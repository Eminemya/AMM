function delta = IdealBP( delta, fl, fh )
%IDEALBP Summary of this function goes here
%   Detailed explanation goes here
    len = size(delta,3);
first = ceil(fl*len);
second = floor(fh*len);
if (first ==second)
    fprintf('WARNING: Bandpass is too narrow. Result will be all zeros.\n');
end
M = size(delta,1);
batches = 10;
batchSize = ceil(M/10);
for k = 1:batches
    idx = 1+batchSize*(k-1):min(k*batchSize, M);
    freqDom = fft(real(delta(idx,:,:)),[],3);
    freqDom(:,:,1:first) = 0;
    freqDom(:,:,second+1:end) = 0;
    delta(idx,:,:) = real(2*single(ifft(freqDom,[],3)));
end
end

