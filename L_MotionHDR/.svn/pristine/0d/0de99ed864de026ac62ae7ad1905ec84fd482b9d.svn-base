% Let's verify the distribution of phases
clear;
close all;
A = linspace(0.5,1,100);
B = cos(2*pi*(0:99)/100*20);
frame = repmat(A.*B,[100 1]);
imagesc(frame);

noiseSigma = 0.01;
noiselessBand = buildG4H4pyr(frame,1,1,0);
noiselessBand = noiselessBand{1};
predPhaseSigma = noiseSigma./abs(noiselessBand);

examples = 1000;
for k = 1:examples
    
    currentFrame = randn(size(frame))*noiseSigma+frame;
    band = buildG4H4pyr(currentFrame, 1,1,0);
    band = band{1};

    values(:,:,k) = band;
    
end
%%
figure();
subplot(2,2,1);
imagesc(abs(noiselessBand), [0 10]);
title('Amplitude');

subplot(2,2,2);
imagesc(angle(noiselessBand));
title('Phase');

subplot(2,2,3);
imagesc(abs(band),[0 10]);
title('Amplitude Noise');

subplot(2,2,4);
imagesc(angle(band))
title('Phase Noise');

%% Variances
actualPhaseSigma = sqrt(var(angle(values),1,3));
figure();
subplot(1,2,1);
imagesc(predPhaseSigma, [0 .01]);
subplot(1,2,2);
imagesc(actualPhaseSigma, [0 .01]);
% off by a factor of 2, corresponds to sqrt(sum(G4.^2)) = 2