close all;
clear;
rootDir = '/home/nwadhwa/Downloads/Vidmag2/Data/release';
vidName = 'crane_crop.avi';

vr = VideoReader(fullfile(rootDir, vidName));
noiseSigma = 0.05;
[covarianceMatrix, precisionMatrix]  = frameToCov002(vr, noiseSigma,[2 3 6]);

signalViewerCov002(vr.read(1), precisionMatrix);

%%
N = size(covarianceMatrix,3);
M = size(covarianceMatrix,4);

maxDir =zeros(N,M);
minDir =zeros(N,M);

for k = 1:N
    for j = 1:M
        C = covarianceMatrix(:,:,k,j);
        if (any(or(isnan(C(:)), isinf(C(:)))))
            maxDir(k,j) = 1e3;
            minDir(k,j) = 1e3;
        else
            [V,D]  = eig(C);
            maxDir(k,j) = min(diag(D));
            minDir(k,j) = max(diag(D));
        end
    end
end
%%
figure();
imagesc(log10(maxDir));
title('Variance in dominant direction');
colorbar;
figure();
imagesc(log10(minDir));
title('Variance in perpendicular direction');
colorbar;

figure();
imagesc(log10(minDir.*maxDir));
title('Variance in both direction');
colorbar;