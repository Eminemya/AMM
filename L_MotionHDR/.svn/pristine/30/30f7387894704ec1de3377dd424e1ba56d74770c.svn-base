%% Try to create an Eulerian cartoon animation filter on a synthetic disk
% This time we use the phaseAmplify frame work from SIGGRAPH 2013
% Neal Wadhwa, February 2014
clear;
close all;

figDir = mfilename;
mkdir(figDir);

path = [linspace(0,40,100)' zeros(100, 1)];
path = cat(1,zeros(25,2), path, cat(2,ones(25,1)*40, zeros(25,1)));
vid = mkPathDiskVid(path, 'diskCenter', [60 80]);
vid = vid +  0.01*randn(size(vid));

vidFile = fullfile(figDir, 'synthDisk02.avi');
writeVideo(vid, 25, vidFile);

alpha = 50;
tSigma = 1;
fh = 0;
fs = 1;
temporalFilter = @FilterAccel01;
outDir = figDir;

phaseAmplifyUnwrap(vidFile, alpha, tSigma, fh, fs, outDir, 'temporalFilter', temporalFilter);

sSigma = 3;
phaseAmplifyUnwrap(vidFile, alpha, tSigma, fh, fs, outDir, 'temporalFilter', temporalFilter,'sigma', sSigma);