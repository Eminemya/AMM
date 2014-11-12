function wind = sharperBandPassFilter(n, L, H, beta)
    n2 = 0.5*(n-1);
    di = 0:(n-1);
    sH = sum(sinc(H*(di-n2)));
    sL = sum(sinc(L*(di-n2)));
    part1 =(1./sH.*sinc(H*(di-n2))-1./sL.*sinc(L*(di-n2)));
    part2 = kaiser(n, beta)'; 
    wind = part1.*part2;
    
end

%% You can make the filter more selective by increasing the number of taps and narrowing the frequency band.
% That is the limiting factor right now is the number oftaps, i think.
% If you think you have enough taps and it is not freqency selective enoguh
% , you can also decrease beta.

%  One hack you could do to determine the number of taps is take the
%  Hilbert transform of the resulting filter and keep adding taps until the
%  minimum value of abs(hilbert(FILT)) is maybe 5 perent of the maximum
%  value
% This works if you assume that the filter has the shape of a windows sine
% wave, which narrowband FIR filters do. 

%% If the number of taps is not the bottlneck, you can decrease the value of beta to further increase the sharpness of the fitler

%% IF you don't want to use these high tap FIR filters, you can use a recursive filter
% A good starting point would be a 2nd order (or higher) butterworth
% filter. To kill the phase response (like the FIR filter), you could apply
% it forwards and then backwards, but then you need to read the whole of
% the video into memory.
% A way to get around this is to do the overlap and save method
% (http://en.wikipedia.org/wiki/Overlap%E2%80%93save_method)
% 
