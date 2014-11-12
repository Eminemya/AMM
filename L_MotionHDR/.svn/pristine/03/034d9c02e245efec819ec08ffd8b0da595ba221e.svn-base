%% Setup data
clear;
close all;
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


figDir = 'spectralPhaseRand';
mkdir(figDir);


%% Frequency
clear freq;
for j = 1:2
    for k = 1:2
        freq{j}{k} = 20*log10(abs(fftn(out{j}{k})));
        freq{j}{k} = freq{j}{k}(:,:,:,1:50);
    end
end

%% Weiner Filtering
% Estimate spectrum of generative process
runs = 1e3;
outName = sprintf('numDisks%d-ampRange%0.2f-%0.2f-freqRange%0.2f-%0.2f-runs%d.mat', ...
    numDisk, ampRange(1), ampRange(2), freqRange(1), freqRange(2), runs);
outName = fullfile('estimateSignalSpectrum', outName);

if (not(exist(outName, 'file')))
    tic; [spectrum, outName] = estimateSignalSpectrum(8, [0 0.3], [0.01 0.25], runs); toc
else    
    load(outName);
end

% Plot
imwrite(mkNormalizedVid(log10(spectrum(:,:,1))), fullfile(figDir, 'spectrumSpace.png'));
figure('Position', [1 1 800 400],'PaperPositionMode', 'auto');
plot(linspace(0,2*pi, 100), log10(squeeze(spectrum(1,1,:))));
xlabel('Normalized Frequency');
ylabel('Log Power');
print(gcf, fullfile(figDir, 'spectrumTime.eps'));

% Spectrum of noise-constant
noiseSpectrum = mean(mean(mean(mean(abs(fftn(motNoise))))));
noiseSpectrum = ones(size(motNoise)).*noiseSpectrum;

% Optimal weiner filter - space-time  symmetric filter
freq = fftn(out{2}{1}); % crappy filtering
meanSpectra = freq.*spectrum./(spectrum+noiseSpectrum);
meanDenoised = ifftn(meanSpectra);


%% Write spectrum to videos
captions = {'Signal', 'Noise', 'Noise + Signal', 'Denoised'};

for k = 1:4
   out50{k} = singleTxt2vid(captions{k},[0 0 0], [1 1 1], 50, 160); 
   out100{k} = singleTxt2vid(captions{k},[0 0 0], [1 1 1], 100, 160); 
end
text50 = concatVidsH(out50);
text100 = concatVidsH(out100);
text50 = im2single(text50(:,:,1,:));
text100 = im2single(text100(:,:,1,:));

vids = mkNormalizedVid(cat(2, out{1}{1}, motNoise, out{2}{1}, meanDenoised));
primal = cat(1,vids, text100);


freqs = linspace(0,1,50);
for k = 1:numel(freqs)
   freqText{k} = sprintf('Fraction of Nyquist Frequency: %0.2f', freqs(k)); 
end
nyquistFreqText = txt2vid(freqText,[0 0 0], [1 1 1], 640,'FontSize',12);
nyquistFreqText = im2single(nyquistFreqText(:,:,1,:));

freqVids = cat(2, abs(fftn(out{1}{1})), abs(fftn(motNoise)), abs(fftn(out{2}{1})), abs(fftn(meanDenoised)));
freqVids = mkNormalizedVid(log10(freqVids));
freqVids = freqVids(:,:,:,1:50);
freqVids = cat(1,freqVids, text50,nyquistFreqText);


writeVideo(primal, 10, fullfile(figDir, 'primalWeinerDenoise.avi'));
writeVideo(freqVids, 10, fullfile(figDir, 'freqWeinerDenoise.avi'));
frame = 15;
imwrite(primal(:,:,1,frame), fullfile(figDir, sprintf('primalWeinerDenoise-frame%d.png', frame)));
imwrite(freqVids(:,:,1,frame), fullfile(figDir, sprintf('freqWeinerDenoise-frame%d.png', frame)));
