% A script to show how the new pyramid is used
% Copyright, Neal Wadhwa, August 2014
%
% Part of the Supplementary Material to:
%
% Riesz Pyramids for Fast Phase-Based Video Magnification
% Neal Wadhwa, Michael Rubinstein, Fredo Durand and William T. Freeman
% Computational Photography (ICCP), 2014 IEEE International Conference on


% Create an impulse image
im = zeros(128,128,'single');
im(65,65) = 1;

% Build the pyramid and show the impulse and frequency responses
[pyr, pind] = buildNewPyr(im);

L = size(pind,1);
figure('Position', [1 1 1000 400]);
for k = 1:L
    subplot(2,L,k);
    imagesc(pyrBand(pyr,pind,k));
    ylabel('Space');
    xlabel('Space');
    title(sprintf('Level %d', k));
end
for k = 1:L
    subplot(2,L,L+k);
    imagesc(abs(fftshift(fft2(pyrBand(pyr,pind,k)))));
    ylabel('Frequency');
    xlabel('Frequency');
end
fprintf('Press any key to continue\n');
pause;

% Collapse the pyramid and compare to original
reconstructed = reconNewPyr(pyr, pind);

figure();
subplot(1,2,1);
imshow(im);
title('Original');
subplot(1,2,2);
imshow(reconstructed);
title('Reconstructed');
fprintf('The error is %0.2fdB\n', -10*log10(mean((im(:)-reconstructed(:)).^2)));
fprintf('Press any key to continue\n');
pause;
%%
% Load a test image built into matlab
im = im2single(imread('cameraman.tif'));

% Build a new pyramid and display it
[pyr, pind] = buildNewPyr(im);

% Show the levels
L = size(pind,1);
figure('Position', [1 1 1200 300]);
for k = 1:L
    subplot(1,L,k);
    imagesc(pyrBand(pyr,pind,k));
    ylabel('Space');
    xlabel('Space');
    title(sprintf('Level %d', k));
end
fprintf('Press any key to continue\n');
pause;


% Show reconstruction
reconstructed = reconNewPyr(pyr,pind);
figure();
subplot(1,2,1);
imshow(im);
title('Original');
subplot(1,2,2);
imshow(reconstructed);
title('Reconstructed');
fprintf('The error is %0.2fdB\n', -10*log10(mean((im(:)-reconstructed(:)).^2)));


