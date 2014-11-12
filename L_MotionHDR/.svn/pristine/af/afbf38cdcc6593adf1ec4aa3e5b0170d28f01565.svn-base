% Let's verify the distribution of phases
clear;
close all;
A = linspace(0.5,1,100);
B = cos(2*pi*(0:99)/100*20);
frame = repmat(A.*B,[100 1]);
imagesc(frame);

[buildPyr, reconPyr] = octave4PyrFunctions(100,100);
noiseSigma = 0.01;

bandIDX = 2:13;
[pyr, pind]  = buildPyr(frame);
for l = bandIDX
    noiselessBand{l} = pyrBand(pyr, pind, l);
    predPhaseSigma{l} = noiseSigma./abs(noiselessBand{l});
end

examples = 1000;
for k = 1:examples
    
    currentFrame = randn(size(frame))*noiseSigma+frame;
    [pyr, pind] = buildPyr(currentFrame);
    for l = bandIDX
        band = pyrBand(pyr, pind, l); 
        values{l}(:,:,k) = band;
    end
    
end
%%
for l = bandIDX
   temp = mod(pi+bsxfun(@minus, angle(values{l}), angle(values{l}(:,:,1))),2*pi)- pi;
   actualPhaseSigma{l} = sqrt(var(temp,1,3)); 
   ratio{l} = actualPhaseSigma{l}./predPhaseSigma{l};
   meanVal(l) = mean(ratio{l}(:));
end
% predictedRatios 
h = 100;
w = 100;
ht = 4;
filters = getFilters([h w], 2.^[0:-1:-ht], 4);
[croppedFilters, filtIDX] = getFilterIDX(filters);
for l = bandIDX
   C = real((ifft2(fftshift(croppedFilters{l}))));
   predictedRatios(l) = sqrt(sum(C(:).^2));
end
