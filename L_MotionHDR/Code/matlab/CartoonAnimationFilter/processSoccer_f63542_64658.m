vidFile = fullfile(getRootDir(), 'MotionHDR', 'Data', 'soccer_f63542-64658.mp4');
alpha = 500;
tSigma = [0.1 1 3 6 12];
fl = 0;
fs = 1;
sSigma = 6;
outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', 'soccer_f63542-64658');
mkdir(outDir);
parfor j = 1:numel(tSigma)
    phaseAmplify2Y(vidFile, alpha, tSigma(j), fl, fs, outDir, 'sigma', sSigma', ...
        'temporalFilter', @FilterAccel01, 'pyrType', 'octave');
end

%alpha = 100;
%phaseAmplify2Y(vidFile, alpha, 0.03, 0.2, fs, outDir, 'sigma', sSigma', ...
%    'temporalFilter', @FiltFiltButter,'useFrames', [480 780], 'pyrType', 'octave');
