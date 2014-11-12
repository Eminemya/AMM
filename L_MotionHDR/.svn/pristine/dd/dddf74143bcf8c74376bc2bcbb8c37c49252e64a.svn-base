vidDir = fullfile(getRootDir(), 'MotionHDR/Data');
vidName = 'ball_flour_02_f1725-2125';
vidFile = fullfile(vidDir, [vidName '.avi']);
alpha = 5;
sigmaT = 1;
fs = 2;
resultsDir = fullfile(getRootDir(), 'MotionHDR/Results', vidName);
mkdir(resultsDir);
phaseAmplify2(vidFile, alpha, sigmaT, 0, fs, resultsDir, 'temporalFilter', @FilterAccel01);


%% Look at phases
vr = VideoReader(vidFile);
vid = rgb2y(im2single(vr.read()));
[buildPyr, reconPyr] = octave4PyrFunctions(size(vid,1), size(vid,2));
[phases, pyrs, pind] = computePhases(vid, buildPyr);
phases = mod(pi+convn(phases, [1 -1],'same'),2*pi)-pi;
phases = pyrVid2CellVid(phases, pind);
pyrs = pyrVid2CellVid(pyrs, pind);