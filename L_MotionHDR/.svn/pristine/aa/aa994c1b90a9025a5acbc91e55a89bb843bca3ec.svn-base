figDir = mfilename;
mkdir(figDir);
%% Process
vidOne = 'SoundAmp0.1.avi';
alpha = 35;
fl = 0;
fs = 1;
phaseAmplify2Y(vidOne, alpha, fl, 0, fs, figDir, 'temporalFilter', @FilterJerk01,'pyrType', 'halfOctave');
phaseAmplify2Y(vidOne, alpha, 15, 25, 100, figDir, 'temporalFilter', @FilterJerkButter,'pyrType', 'halfOctave');

%% Compute phases
vr = VideoReader(vidOne);
vid = vr.read();
vid = rgb2y(im2single(vid));
[buildPyr, reconPyr] = octave4PyrFunctions(200,200);
[phases, pyrs, pind] = computePhases(vid,buildPyr, 1);
phases = pyrVid2CellVid(phases, pind);
pyrs = pyrVid2CellVid(pyrs, pind);

%% Velocity
kernel = [1 -1];
tKernel(1,1,1,:) = kernel;
spice = mod(pi+convn(phases{2}, tKernel,'same'),2*pi)-pi;

velocity = (abs(pyrs{2})>0.01).*spice;

%% Acceleration
kernel = [-1 2 -1];
clear tKernel;
tKernel(1,1,1,:) = kernel;
spice = mod(pi+convn(phases{2}, tKernel,'same'),2*pi)-pi;

acceleration = (abs(pyrs{2})>0.01).*spice;

%% Jerk
kernel = [-1 3 -3 1];
clear tKernel;
tKernel(1,1,1,:) = kernel;
spice = mod(pi+convn(phases{6}, tKernel,'same'),2*pi)-pi;

jerk = (abs(pyrs{6})>0.01).*spice;