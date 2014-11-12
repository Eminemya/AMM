%% Init
clear;
close all;
figDir = mfilename;
mkdir(figDir);

%% Setup data
motionNoise = 0.1;
imageNoise = 0.01;
ampRange = [0 0.3];
freqRange = [0.01 .25];
numDisk = 8;

[out{1}{1}, amp] = mkSynthPhaseRand(numDisk, ampRange, freqRange, 0, 0);

imNoise = mkImageNoise(zeros(size(out{1}{1})), amp, imageNoise);
motNoise = mkMotionNoise(zeros(size(out{1}{1})), motionNoise);
out{1}{2} = out{1}{1} + imNoise;
out{2}{1} = out{1}{1} + motNoise;
out{2}{2} = out{1}{1} + imNoise + motNoise;

for k = 1:2
    for j = 1:2
        energy{j}{k} = sqrt(sum(out{j}{k}.^2,4));
    end
end


%% Figure 01
frame = 50;
for j = 1:2
    for k = 1:2
        frames{j}{k} = mkNormalizedVid(out{j}{k}(:,:,1,frame),'inputRange', [-pi pi], 'outputRange', [0, 1]);        
        imwrite(frames{j}{k}, fullfile(figDir, sprintf('phaseSig_m%d_i%d.png', j-1, k-1)));
        energyOut{j}{k} = mkNormalizedVid(energy{j}{k}, 'inputRange', [0.5 4]);
        imwrite(energyOut{j}{k}, fullfile(figDir, sprintf('energy_m%d_i%d.png', j-1, k-1)));
    end
end

imwrite(mkNormalizedVid(amp), fullfile(figDir, 'amp.png'));

% energies


