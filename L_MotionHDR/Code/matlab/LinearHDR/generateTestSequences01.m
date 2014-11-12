%% Init

figDir = mfilename;
mkdir(figDir);

%% First sequene with no noise
centers = [80 40; 80 80; 80 120];
motionAmps = [0.01 0; 0.1 0; 1 0];
gaussSize = 5;
for k = 1:size(centers,1)
   vidList{k} = mkGaussVid('gaussianCenter', centers(k,:), 'gaussianSize', gaussSize, 'motionAmplitude', motionAmps(k,:));
end
vid = mkMergeVid(vidList);
noise = 0;
vid = mkNoisyVid(vid, noise);
vid = mkGaussNormVid(vid);
writeVideo(vid, 25, fullfile(figDir, 'testSequence01.avi'));


%% Second sequence, same thing but with moderate image noise

centers = [80 40; 80 80; 80 120];
motionAmps = [0.01 0; 0.1 0; 1 0];
gaussSize = 5;
for k = 1:size(centers,1)
   vidList{k} = mkGaussVid('gaussianCenter', centers(k,:), 'gaussianSize', gaussSize, 'motionAmplitude', motionAmps(k,:));
end
vid = mkMergeVid(vidList);
noise = 0.01;
vid = mkNoisyVid(vid, noise);
vid = mkGaussNormVid(vid);
writeVideo(vid, 25, fullfile(figDir, 'testSequence02-sigman0.01.avi'));

