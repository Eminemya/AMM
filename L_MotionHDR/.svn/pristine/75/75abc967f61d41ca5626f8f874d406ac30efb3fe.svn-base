%% Script to show what the distribution of the motion noise is 
% Neal Wadhwa, 2014

figDir = mfilename;
mkdir(figDir);

vidFile = fullfile(getRootDir(), 'Vidmag2/Data/guitar.avi');
vr = VideoReader(vidFile);
vid = rgb2y(im2single(vr.read()));
[buildPyr,~] = octave4PyrFunctions(size(vid,1), size(vid,2));

[phases, pyrs, pind] = computePhases(vid, buildPyr, 1);
phases = pyrVid2CellVid(phases, pind);
amps = pyrVid2CellVid(abs(pyrs), pind);
clear pyrs;

%% Estimate image noise
spice = vid(1:20, 120:180,:,:);
timeAverage = mean(mean(spice,1),2);
spice = bsxfun(@minus, spice, timeAverage);

ff = figure('Position', [1 1 640 320], 'PaperPositionMode', 'auto');
hist(spice(:),100);
xlabel('Deviation from Mean');
ylabel('Count');
saveas(ff, fullfile(figDir, 'imageNoiseHistogram.eps'), 'psc2');
imageNoiseSigma = sqrt(mean(spice(:).^2))


%% Estimate Motion Noise, only look at points where beta>10, so that image noise is negligible
clear series;
level  = 8; 
cutoff = 80;
ampLevel = amps{level}./imageNoiseSigma*4; %4 is to compensate for blurring of imageNoiseSigma
mask = (ampLevel(:,:,1,1)>cutoff);

phaseLevel = phases{level};

for k = 2:size(vid,4)
   temp = phaseLevel(:,:,1,k);
   series(:,k) = temp(mask);
end



ff = figure('Position', [1 1 640 320], 'PaperPositionMode', 'auto');
hist(series(:),100);
xlabel('Deviation from Mean');
ylabel('Count');
saveas(ff, fullfile(figDir, 'motionNoiseHistogram.eps'), 'psc2');
motionNoiseSigma = sqrt(mean(series(:).^2))
%% Auto correlation function of a point
B = xcorr(squeeze(phaseLevel(16,144,1,:)));
weights=  [1:300 299:-1:1]';
B = B./weights;
B = flipud(B(1:300));

ff = figure('Position', [1 1 640 320], 'PaperPositionMode', 'auto');
plot(B);
xlabel('Time Difference');
saveas(ff, fullfile(figDir, 'crossCorrelation.eps'), 'psc2');

imwrite(vid(:,:,1,1), fullfile(figDir,'guitar.png'));

