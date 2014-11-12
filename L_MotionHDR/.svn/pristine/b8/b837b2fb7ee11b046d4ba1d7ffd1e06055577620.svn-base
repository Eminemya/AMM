vidDir = fullfile(getRootDir(), 'VisualMic/SoundVisualization/Data_20140212');
vidNames = {'ball_flour_01', 'ball_flour_02', 'Clap_flour_01', 'RightAngle_flour_01', 'RightAngle_flour_02', 'RightAngle_flour_03', 'RightAngle_smoke_01', 'RightAngle_smoke_02', 'Snap_flour_01'};
%vidDir = fullfile(getRootDir(), 'MotionHDR/Data');
%vidNames = {'ball_flour_02_f1725-2125'};
alphas = [5, 25, 100];
sigmaT = 1;
fs = 2;
for k = 1:numel(vidNames)
    parfor j = 1:numel(alphas)
        vidFile = fullfile(vidDir, [vidNames{k} '.avi']);
        resultsDir = fullfile(getRootDir(), 'VisualMic/Results', vidNames{k});
        mkdir(resultsDir);
        alpha = alphas(j);        
        phaseAmplify2(vidFile, alpha, 0, 0, fs, resultsDir, 'temporalFilter', @FilterJerk01);
        phaseAmplify2(vidFile, alpha, sigmaT, 0, fs, resultsDir, 'temporalFilter', @FilterJerk01);
    end
end


