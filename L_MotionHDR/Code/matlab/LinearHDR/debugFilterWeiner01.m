clear;
close all;
N = 3e2;
t = (0:N)/N;
signal = sin(2*pi*t*60);
vid(1,1,:) = signal;
vid = repmat(vid,[100, 100]);
vid = vid + randn(size(vid));

oneD(1,1,:) = signal;
oneD = oneD + 0.1*randn(size(oneD));

out = FilterWeiner01(oneD, 0.01, 30);
figure();
plot(squeeze(oneD));
hold on;
plot(squeeze(out),'r');

%% Video
outV = FilterWeiner01(vid, 0.01, 30);
implay(normalize(cat(2,vid, outV)));

%% Guitar

vidFile = fullfile(getRootDir(), 'Vidmag2/Data', 'guitar.avi');
[~, vidName, ~] = fileparts(vidFile);
alpha = 25;
fl = 20;
fs = 600;
fh = 60*fs; % number of taps
tfilt = @FilterWeiner01;    
outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', func2str(tfilt));
mkdir(outDir);

outName{1} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt);
outName{2} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter);
sigma = 2;
outName{3} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt,'sigma',sigma);
outName{4} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter,'sigma',sigma);
fl = 72;
fh = 92;
outName{5} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir);
outName{6} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'sigma',sigma);
spice{1} = vidFile;
spice{2} = fullfile(outDir, outName{2});
spice{3} = fullfile(outDir, outName{5});
spice{4} = fullfile(outDir, outName{1});
spice{5} = vidFile;
spice{6} = fullfile(outDir, outName{4});
spice{7} = fullfile(outDir, outName{6});
spice{8} = fullfile(outDir, outName{3});
captions = {'Input', 'Highpass', 'Manual', 'Auto Weiner', 'Input', 'Highpass + Reg.', 'Manual + Reg.', 'Auto Weiner + Reg.'};
vidgridMJPEG(spice, captions, fullfile(outDir, sprintf('comparison-%s.avi',vidName)),[2 4]);


%% Car_engine
vidFile = fullfile(getRootDir(), 'Vidmag2/Data/release', 'car_engine.avi');
[~, vidName, ~] = fileparts(vidFile);
alpha = 20;
fl = 5;
fs = 400;
fh = 60*fs; % number of taps
tfilt = @FilterWeiner01;
outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', func2str(tfilt));
mkdir(outDir);

outName{1} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt,'scaleVideo', 0.25);
outName{2} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter,'scaleVideo', 0.25);
sigma = 2;
outName{3} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt,'sigma',sigma,'scaleVideo', 0.25);
outName{4} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter,'sigma',sigma,'scaleVideo', 0.25);
fl = 15;
fh = 25;
outName{5} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'scaleVideo', 0.25);
outName{6} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'sigma',sigma,'scaleVideo',0.25);
spice{1} = vidFile;
spice{2} = fullfile(outDir, outName{2});
spice{3} = fullfile(outDir, outName{5});
spice{4} = fullfile(outDir, outName{1});
spice{5} = vidFile;
spice{6} = fullfile(outDir, outName{4});
spice{7} = fullfile(outDir, outName{6});
spice{8} = fullfile(outDir, outName{3});
captions = {'Input', 'Highpass', 'Manual', 'Auto Weiner', 'Input', 'Highpass + Reg.', 'Manual + Reg.', 'Auto Weiner + Reg.'};
vidgridMJPEG(spice, captions, fullfile(outDir, sprintf('comparison-%s.avi',vidName)),[2 4]);

%% Throat
vidFile = fullfile(getRootDir(), 'Vidmag2/Data/release', 'throat.avi');
[~, vidName, ~] = fileparts(vidFile);
alpha = 50;
fl = 20;
fs = 1900;
fh = 60*fs; % number of taps
scale = 0.4;
tfilt = @FilterWeiner01;
outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', func2str(tfilt));
mkdir(outDir);

outName{1} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt,'scaleVideo', scale);
outName{2} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter,'scaleVideo', scale);
sigma = 2;
outName{3} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt,'sigma',sigma,'scaleVideo', scale);
outName{4} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter,'sigma',sigma,'scaleVideo', scale);
fl = 90;
fh = 110;
outName{5} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'scaleVideo', scale);
outName{6} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'sigma',sigma,'scaleVideo',scale);
spice{1} = vidFile;
spice{2} = fullfile(outDir, outName{2});
spice{3} = fullfile(outDir, outName{5});
spice{4} = fullfile(outDir, outName{1});
spice{5} = vidFile;
spice{6} = fullfile(outDir, outName{4});
spice{7} = fullfile(outDir, outName{6});
spice{8} = fullfile(outDir, outName{3});
captions = {'Input', 'Highpass', 'Manual', 'Auto Weiner', 'Input', 'Highpass + Reg.', 'Manual + Reg.', 'Auto Weiner + Reg.'};
vidgridMJPEG(spice, captions, fullfile(outDir, sprintf('comparison-%s.avi',vidName)),[2 4]);

%% Pipe
vidFile = fullfile(getRootDir(), 'Vidmag2/Data/', 'test25_1000_2000_compress.avi');
[~, vidName, ~] = fileparts(vidFile);
alpha = 120;
fl = 120;
fs = 20000;
fh = 60*fs; % number of taps
scale = 0.4;
tfilt = @FilterWeiner01;
outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', func2str(tfilt));
mkdir(outDir);

outName{1} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt,'scaleVideo', scale);
outName{2} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter,'scaleVideo', scale);
sigma = 2;
outName{3} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', tfilt,'sigma',sigma,'scaleVideo', scale);
outName{4} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'temporalFilter', @FilterHighpassButter,'sigma',sigma,'scaleVideo', scale);
fl = 440;
fh = 540;
outName{5} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'scaleVideo', scale);
outName{6} = phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir,'sigma',sigma,'scaleVideo',scale);
spice{1} = vidFile;
spice{2} = fullfile(outDir, outName{2});
spice{3} = fullfile(outDir, outName{5});
spice{4} = fullfile(outDir, outName{1});
spice{5} = vidFile;
spice{6} = fullfile(outDir, outName{4});
spice{7} = fullfile(outDir, outName{6});
spice{8} = fullfile(outDir, outName{3});
captions = {'Input', 'Highpass', 'Manual', 'Auto Weiner', 'Input', 'Highpass + Reg.', 'Manual + Reg.', 'Auto Weiner + Reg.'};
vidgridMJPEG(spice, captions, fullfile(outDir, sprintf('comparison-%s.avi',vidName)),[2 4]);
