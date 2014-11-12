%% The way Quanta gets the respiration rate and heart rate from video doesn't make much sense in the case of motion.
% The averaging doesn't make sense
% It is ok for color I think? The main problem for motion is that the sign
% of the signal depends on local image gradient. 
clear;
close all;

figDir = [mfilename '-horizontal'];
mkdir(figDir);

videos{1} = fullfile(figDir, 'input.avi');
videos{2} = fullfile(figDir, 'colorVariations.avi');
videos{3} = fullfile(figDir, 'phaseVariations.avi');
videos{4} = fullfile(figDir, 'amplitudeVariations.avi');


%% We will demosntrate the problems on the motions of a fiducial marker

im = imread('marker.png');
im = 1-rgb2y(im2single(im));
vid = mkImageVid(im,'motionAmplitude', [0 1]);
vid = vid+randn(size(vid))*0.01;
writeVideo(im2uint8(vid),10,videos{1});

%% Color variations
for k = 1:size(vid,4);
   blurVid(:,:,1,k) = upBlur(blurDn(vid(:,:,1,k),2),2);
end
blurVid = bsxfun(@minus, blurVid,blurVid(:,:,1,1));
writeVideo(mkNormalizedVid(blurVid), 10, videos{2});

groundTruth = squeeze(blurVid(15,79,1,:));
recoveredSignal = squeeze(mean(mean(blurVid,1),2));
figure('PaperPositionMode','auto', 'Position',[1 1 600 300]);
plot(groundTruth,'b');
hold on;
plot(recoveredSignal,'r');
xlabel('Time (samples)');
ylabel('Motion');
legend({'Ground Truth', 'Averaged Signal'},'Location', 'Best');
saveas(gcf, fullfile(figDir, 'signalComparison.eps'),'psc2');


%% Phase Variations
[buildPyr, reconPyr] = octave4PyrFunctions(160,160);
[phases, pyrs, pind] = computePhases(vid, buildPyr, 1);
phases = pyrVid2CellVid(phases, pind);
amps = pyrVid2CellVid(abs(pyrs), pind);
level = 6;
phaseVid = vidresize(phases{level}, [160 160]);
ampVid = vidresize(amps{level}, [160 160]);
writeVideo(mkNormalizedVid(phaseVid), 10, videos{3});
writeVideo( mkNormalizedVid(ampVid), 10, videos{4});

recoveredPhase = squeeze(mean(mean(phaseVid,1),2));
recoveredPhaseAverage = squeeze(mean(mean(ampVid.*phaseVid,1),2))./(eps+squeeze(mean(mean(ampVid,1),2)));
figure('PaperPositionMode','auto', 'Position',[1 1 1000 300]);
plot(groundTruth./max(abs(groundTruth(:))),'b');
hold on;
plot(recoveredSignal,'r');
plot(recoveredPhase./max(abs(recoveredPhaseAverage(:))), 'g');
plot(recoveredPhaseAverage./max(abs(recoveredPhaseAverage(:))), 'magenta--');

xlabel('Time (samples)');
ylabel('Motion');
legend({'Ground Truth', 'Eulerian Average Signal', 'Averaged Phase', 'Amp. Weighted Average'},'Location', 'EastOutside');
saveas(gcf, fullfile(figDir, 'signalComparison2.eps'),'psc2');


%% Display Videos
captions = {'Input', 'Intensity Variations', 'PhaseVariations', 'Amplitudes'};
vidgridMJPEG(videos, captions, fullfile(figDir, 'fullVideo.avi'));

