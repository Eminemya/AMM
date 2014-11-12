%% We will do linear HDR processing without any temporal filter 
% The amplification factor will be such that 

function [ outName ] = processMotionHDR01(vidFile, maxPhase, outDir, varargin)
    
    %% Read Video
    vr = VideoReader(vidFile);
    [~, writeTag, ~] = fileparts(vidFile);
    FrameRate = vr.FrameRate;    
    vid = vr.read();
    [h, w, nC, nF] = size(vid);
    [buildPyr, reconPyr] = octave4PyrFunctions(h,w);
    
    vid = rgb2y(im2single(vid));    
    [phases, pyrs, pind] = computePhases(vid, buildPyr);
    phases = unwrap(phases, [], 2);
    phases = bsxfun(@minus, phases, mean(phases,2));
    res = zeros(h,w,1,nF,'uint8');
    for k = 1:nF
       exp(1i*phases 
    end
    
    
end

