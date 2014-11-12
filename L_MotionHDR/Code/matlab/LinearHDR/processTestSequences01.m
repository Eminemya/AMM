
vidFile = fullfile('generateTestSequences01', 'testSequence01.avi');

vr = VideoReader(vidFile);
[~, writeTag, ~] = fileparts(vidFile);
FrameRate = vr.FrameRate;    
vid = vr.read();
[h, w, nC, nF] = size(vid);
[buildPyr, reconPyr] = octave4PyrFunctions(h,w);

[phases, pyrs, pind] = computePhases(vid, buildPyr);
phaseVid = pyrVid2CellVid(phases, pind);