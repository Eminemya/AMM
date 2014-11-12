%% Init
clear;
close all;
figDir = mfilename;
mkdir(figDir);

%% IMage Noise
diskSize =40;
diskCenter = [ 80 80];
motionAmplitude = [0 0.5];
alpha = 6;
imageNoise = 0.03;

vid   = mkDiskVid('diskCenter', diskCenter, 'motionAmplitude',motionAmplitude,'diskSize', diskSize);
vid = vid*0.25+0.5;
noise = randn(size(vid))*imageNoise;
vidMN = vid+  noise;
vidGT   = mkDiskVid('diskCenter', diskCenter, 'motionAmplitude',motionAmplitude*alpha,'diskSize', diskSize);
vidGT = vidGT + noise;
vid = repmat(vid, [1 1 3]);
vidMN = repmat(vidMN, [1 1 3]);

vidGT = repmat(vidGT, [1 1 3]);
vidGT = clip(vidGT, 0, 1);


vidMN = clip(vidMN,0,1);

[buildPyr, ~] = octave4PyrFunctions(160,160,2);
[phases, ~, pind] = computePhases(vid, buildPyr, 100);
[phases2, ~, pind] = computePhases(vidMN, buildPyr, 100);
phases = pyrVid2CellVid(phases, pind);
phases2 = pyrVid2CellVid(phases2, pind);
level = 7;

phasesVis = repmat(phases{level},[1 1 3]);
phases2Vis = repmat(phases2{level},[1 1 3]);


%% Write Videos
vidDomain{1} = fullfile(figDir, 'original.avi');
vidDomain{2} = fullfile(figDir, 'noisy.avi');
writeVideo(vid, 10, vidDomain{1});
writeVideo(vidMN, 10, vidDomain{2});

phaseDomain{1} = fullfile(figDir, 'originalPhase.avi');
phaseDomain{2} = fullfile(figDir, 'noisyPhase.avi');
writeVideo(phasesVis, 10, phaseDomain{1});
writeVideo(phases2Vis, 10, phaseDomain{2});


%% Phase Video
amp = abs(buildPyr(vid(:,:,1,1)))>0.1;
amp = pyrVid2CellVid(amp, pind);

A = zeros(160,160);
A(80,80) = 1;
impulseResponse = real(buildPyr(A));
impulseResponse = (pyrVid2CellVid(impulseResponse,pind));

border = 4;
captions = {'Filter', 'No Noise', 'Noisy', 'Narrowband', 'Weiner'};    
for j =1 :numel(captions)
    captionIm{j} = singleTxt2vid(captions{j}, [0 0 0], [1 1 1], size(vid, 4), size(vid,2));
end
outCaptions = concatVidsH(captionIm, border);


for k = 2:size(pind,1)-1
    phases3{k} = FilterWeiner01(squeeze(phases2{k}(:,:,1,:)), 0.01, 10);
    phases3{k} = permute(phases3{k},[1 2 4 3]);
 
    phases4{k} = FiltFiltButter(squeeze(phases2{k}(:,:,1,:)), 0.02, 0.08);
    phases4{k} = permute(phases4{k},[1 2 4 3]);
    
    Aphases{k} = bsxfun(@times, phases{k}, amp{k});
    Aphases2{k} = bsxfun(@times, phases2{k}, amp{k});
    Aphases3{k} = bsxfun(@times, phases3{k}, amp{k});
    Aphases4{k} = bsxfun(@times, phases4{k}, amp{k});
    
    temp{1} = mkNormalizedVid(repmat(imresize(impulseResponse{k}, [size(vid,1), size(vid,2)]), [1 1 1 size(vid,4)]));
    temp{2} = vidresize(Aphases{k}, [size(vid,1), size(vid,2)]);
    temp{3} = vidresize(Aphases2{k}, [size(vid,1), size(vid,2)]);
    temp{5} = vidresize(Aphases3{k}, [size(vid,1), size(vid,2)]);
    temp{4} = vidresize(Aphases4{k}, [size(vid,1), size(vid,2)]);
    outVid = mkNormalizedVid(clip(concatVidsH(temp(2:5), border),[-1 1]));
    outVid = concatVidsH({temp{1}, outVid}, border);
    
    outVid = cat(1,outVid, outCaptions(:,:,1,:));
    
    writeVideo(outVid, 10, fullfile(figDir, sprintf('phaseLevel%d.avi', k)));
    
end


%% Motion Magnified videos
vidDomain{3} = phaseAmplify2(vidDomain{2}, alpha, 0.01, 1,1,figDir, 'temporalFilter', @FilterHighpassButter);
vidDomain{4} = phaseAmplify2(vidDomain{2}, alpha, 0.02, 0.08,1,figDir, 'temporalFilter', @FiltFiltButter);
vidDomain{5} = phaseAmplify2(vidDomain{2}, alpha, 0.01, 10,1,figDir, 'temporalFilter', @FilterWeiner01);
for k = 3:5
    vidDomain{k} = fullfile(figDir, vidDomain{k});
end
for k = 1:5
   vr = VideoReader(vidDomain{k});
   vid = vr.read();
   vidDomain{k} = fullfile(figDir, sprintf('spiceVid%d.avi', k));
   writeVideo(vid(:,1:104,:,51:end),10,vidDomain{k});
   
end



captions = {'Not Noisy', 'Noisy Input', 'Baseline', 'Narrowband Filter','Weiner Filtered'};
vidgridMJPEG(vidDomain, captions, fullfile(figDir, 'vidDomainComparison.avi'));

%% Visualize all the stuff


vidMN = clip(vidMN,0,1);
spice = vidcube(im2uint8(mkNormalizedVid(vid(:,1:104,:,51:end),'inputRange',[-1 2])));
spiceMN = vidcube(im2uint8(mkNormalizedVid(vidMN(:,1:104,:,51:end), 'inputRange',[-1 2])));

spice5 = vidcube(MyVideoReader(vidDomain{3}));
spice3 = vidcube(MyVideoReader(vidDomain{4}));
spice4 = vidcube(MyVideoReader(vidDomain{5}));
spice6 = vidcube(im2uint8(mkNormalizedVid(vidGT(:,1:104,:,51:end), 'inputRange',[-1 2])));
saveas(spice, fullfile(figDir, 'original.pdf'));
saveas(spiceMN, fullfile(figDir, 'noisy.pdf'));
saveas(spice3, fullfile(figDir, 'narrowband.pdf'));
saveas(spice4, fullfile(figDir, 'weiner.pdf'));
saveas(spice5, fullfile(figDir, 'baseline.pdf'));
saveas(spice6, fullfile(figDir, 'groundTruth.pdf'));



level = 7;
phasesVis = repmat(Aphases{level},[1 1 3]);
phases2Vis = repmat(Aphases2{level},[1 1 3]);
phases3Vis = repmat(Aphases3{level},[1 1 3]);
phases4Vis = repmat(Aphases4{level},[1 1 3]);

phasesVis  = clip(phasesVis, -1, 1);
phases2Vis = clip(phases2Vis,-1,1);
phases3Vis = clip(phases3Vis, -1, 1);
phases4Vis = clip(phases4Vis,-1,1);

phasesVis  = mkNormalizedVid(phasesVis);
phases2Vis = mkNormalizedVid(phases2Vis);
phases3Vis = mkNormalizedVid(phases3Vis);
phases4Vis = mkNormalizedVid(phases4Vis);


spicePhase = vidcube(phasesVis(:,1:26,:,51:end));
spicePhaseMN = vidcube(phases2Vis(:,1:26,:,51:end));
spicePhase3 = vidcube(phases3Vis(:,1:26,:,51:end));
spicePhase4 = vidcube(phases4Vis(:,1:26,:,51:end));
saveas(spicePhase, fullfile(figDir, 'originalPhase.pdf'));
saveas(spicePhaseMN, fullfile(figDir, 'noisyPhase.pdf'));
saveas(spicePhase3, fullfile(figDir, 'weinerPhase.pdf'));
saveas(spicePhase4, fullfile(figDir, 'narrowbandPhase.pdf'));


imwrite(mkNormalizedVid(impulseResponse{level}), fullfile(figDir, sprintf('impulse%d.png', level)));

