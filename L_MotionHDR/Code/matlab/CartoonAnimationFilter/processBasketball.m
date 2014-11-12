vidFile = fullfile(getRootDir(), 'MotionHDR', 'Data', 'basketball_bounce4.mp4');
alpha = 500;
tSigma  = 3;
fl = 0;
fs = 1;
sSigma = 6;
outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', 'basketball_bounce4');
mkdir(outDir);

phaseAmplify2Y(vidFile, alpha, tSigma, fl, fs, outDir, 'sigma', sSigma', ...
    'temporalFilter', @FilterAccel01,'useFrames', [480 780], 'pyrType', 'octave');

%alpha = 100;
%phaseAmplify2Y(vidFile, alpha, 0.03, 0.2, fs, outDir, 'sigma', sSigma', ...
%    'temporalFilter', @FiltFiltButter,'useFrames', [480 780], 'pyrType', 'octave');
