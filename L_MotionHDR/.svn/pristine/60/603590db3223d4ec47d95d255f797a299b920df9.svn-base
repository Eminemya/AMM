vidNames = {'abe_soccer01-f1099_2414', 'soccer_neal01-f13507_14415', 'soccer_neal01-f15679_16284'};


alpha = 250;
tSigma = [0.1 1 3 6 12];
fl = 0;
fs = 1;
sSigma = 3;
for k = 1:numel(vidNames);
    vidFile = fullfile(getRootDir(), 'MotionHDR', 'Data', [vidNames{k} '.avi']);
    outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', vidNames{k});
    mkdir(outDir);
    parfor j = 1:numel(tSigma)
        phaseAmplify2Y(vidFile, alpha, tSigma(j), fl, fs, outDir, 'sigma', sSigma', ...
            'temporalFilter', @FilterAccel01, 'pyrType', 'octave');
    end
end
%alpha = 100;
%phaseAmplify2Y(vidFile, alpha, 0.03, 0.2, fs, outDir, 'sigma', sSigma', ...
%    'temporalFilter', @FiltFiltButter,'useFrames', [480 780], 'pyrType', 'octave');
