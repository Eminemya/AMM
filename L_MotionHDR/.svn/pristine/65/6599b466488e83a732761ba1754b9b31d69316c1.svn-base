vidNames = {'abe_soccer01-f1099_2414_w320'};

vidFile = fullfile(getRootDir(), 'MotionHDR', 'Data', [vidNames{1} '.avi']);
outDir = fullfile(getRootDir(), 'MotionHDR', 'Results', vidNames{1});
mkdir(outDir);

%% Trial 1
alpha = 1250;
tSigma = 6;
fl = 0;
fs = 1;
sSigma = 3;   
phaseAmplify2Y(vidFile, alpha, tSigma, fl, fs, outDir, 'sigma', sSigma', ...
    'temporalFilter', @FilterAccel01, 'pyrType', 'octave2');
%% Trial 2
alpha = 100;
fl = 0.5;
fh = 5;
fs = 2000;
sSigma = 3;   
phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir, 'sigma', sSigma', ...
    'temporalFilter', @FilterVelButter, 'pyrType', 'octave2','useFrames',[ 1 300]);

%% Trial 3
alpha = 100;
fl = 0.5;
fh = 5;
fs = 2000;
sSigma = 3;   
phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir, 'sigma', sSigma', ...
    'temporalFilter', @FilterVelButter7, 'pyrType', 'octave2','useFrames',[ 1 300]);

%% Trial 4
alpha = 10;
fl = 0.5;
fh = 2;
fs = 2000;
sSigma = 3;   
phaseAmplify2Y(vidFile, alpha, fl, fh, fs, outDir, 'sigma', sSigma', ...
    'temporalFilter', @FiltFiltButter, 'pyrType', 'octave2','useFrames',[ 301 900]);