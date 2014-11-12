vidDir = fullfile(getRootDir(), 'MotionHDR/Data');
vidName = 'ball_flour_02';
vidFile = fullfile(vidDir, [vidName '.avi']);


%% Look at phases
frames = [1 200];
vr = VideoReader(vidFile);
vid = rgb2y(im2single(vr.read(frames)));
[buildPyr, reconPyr] = octave4PyrFunctions(size(vid,1), size(vid,2));
[phases, pyrs, pind] = computePhases(vid, buildPyr);
phases = mod(pi+convn(phases, [1 -1],'same'),2*pi)-pi;
phases = pyrVid2CellVid(phases, pind);
pyrs = pyrVid2CellVid(abs(pyrs), pind);

cellfun(@(x) sum(x(:))/(vr.Height*vr.Width), pyrs)

%% Look at phases2

vidDir = fullfile(getRootDir(), 'MotionHDR/Data');
vidName = 'ball_flour_02_f1725-2125';
vidFile = fullfile(vidDir, [vidName '.avi']);


vr = VideoReader(vidFile);
vid = rgb2y(im2single(vr.read()));
[buildPyr, reconPyr] = octave4PyrFunctions(size(vid,1), size(vid,2));
[phases2, pyrs2, pind] = computePhases(vid, buildPyr);
phases2 = mod(pi+convn(phases2, [1 -1],'same'),2*pi)-pi;
phases2 = pyrVid2CellVid(phases2, pind);
pyrs2 = pyrVid2CellVid(pyrs2, pind);

%% Right side of frame
WW = 129:256;
out = cat(2,phases{6}(:,WW,:,:), phases2{6}(:,WW,:,:));