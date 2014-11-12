close all;
clear;
rootDir = '/home/nwadhwa/Downloads/Vidmag2/Data/';
vidName = 'guitar.avi';

vr = VideoReader(fullfile(rootDir, vidName));
noiseSigma = 0.05;
[covarianceMatrix, precisionMatrix, mu, postProb]  = frameToCov003(vr, noiseSigma, [6:9],[1 10]);

