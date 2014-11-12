function [ in ] = HilbertM( in, dimen )
% Computes hilbert transform of signal in given dimension
 N = ndims(in);
 spice = 1:N;
 spice(1) = dimen;
 spice(dimen) = 1;
 in = permute(in, spice);
 in = hilbert(in);
 in = permute(in ,spice);


end

