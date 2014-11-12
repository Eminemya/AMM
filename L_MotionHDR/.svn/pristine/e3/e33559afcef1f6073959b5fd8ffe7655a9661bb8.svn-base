classdef MyVideoReader < handle
% A wrapper class for MATLAB's mmreader (now VideoReader) for enhanced
% functionality. For example, also supports image sequences.
% 
% Michael Rubinstein, MIT 2010


properties (Constant)
    % video type enum
    VID_FILE = 0 % video file
    VID_SEQ = 1 % image sequence

    VIDOBJ_MMREADER = 0 % for older MATLAB versions
    VIDOBJ_VIDEOREADER = 1
end


properties (GetAccess = public, SetAccess = immutable)
    width
    height
    length
    nChannels
    path
    name
end

properties (SetAccess = private)
    vidType
    frames
    format
    vidObj
    vidObjType
end


methods
    function o = MyVideoReader(filename)
        [o.path,o.name] = fileparts(filename);
        o.frames = [];
        o.vidObj = [];

        %--- Image sequence
        if isdir(filename) 
            o.frames = imdir(filename);
            ref = imread(fullfile(filename,o.frames(1).name));
            [o.height,o.width,o.nChannels] = size(ref);
            o.length = length(o.frames);
            [~,~,format] = fileparts(o.frames(1).name);
            o.format = format(2:end);
            o.vidType = o.VID_SEQ;

        %--- Video file
        else 
            if exist('VideoReader','class')==8
                o.vidObj = VideoReader(filename);
                o.width = o.vidObj.Width; 
                o.height = o.vidObj.Height;
                o.nChannels = o.vidObj.BitsPerPixel/8;
                o.length = o.vidObj.NumberOfFrames;
                o.vidObjType = o.VIDOBJ_VIDEOREADER;
            else % backward compatibility. Assumes mmreader exists...
                o.vidObj = mmreader(filename);
                o.width = get(o.vidObj,'Width');
                o.height = get(o.vidObj,'Height');
                o.length = get(o.vidObj,'NumberOfFrames');
                o.format = get(o.vidObj,'VideoFormat');
                o.vidObjType = o.VIDOBJ_MMREADER;
            end
            o.vidType = o.VID_FILE;
        end
    end
    
    function delete(o)
        o.close;
    end

    function close(o)
        if o.vidType==o.VID_FILE
            clear o.vidObj;
        elseif o.vidType==o.VID_SEQ
            % TODO
        end
    end

    function [height,width,length,nChannels] = dimensions(o)
        height = o.height;
        width = o.width;
        length = o.length;
        nChannels = o.nChannels;
    end

    function res = resolution(o)
        res = [o.height,o.width];
    end
    
    function fr = frameRate(o)
        if o.vidType==o.VID_FILE
            fr = o.vidObj.FrameRate;
        else
            fr = [];
        end
    end

    % Fetchs frame t from the video
    function frame = frame(o,t)
        frame = [];
        if t<1 | t>o.length
            return;
        end
        if o.vidType==o.VID_FILE
            frame = read(o.vidObj,t);
        elseif o.vidType==o.VID_SEQ
            frame = imread(fullfile(o.path,o.name,o.frames(t).name));
        end
    end

    function name = frameName(o,t)
        if t<1 | t>o.length
            name = []; return;
        end
        if o.vidType==o.VID_FILE
            name = sprintf('%s_%05d',o.name,t);
        elseif o.vidType==o.VID_SEQ
            [tmp,name] = fileparts(o.frames(t).name);
        end
    end

    % Loads the video sequence to memory as a WxHxCxT matrix
    %  frames (optional) - vector of frames to load
    %  grayscale (optional) - load video in grayscale?
    function seq = load(o,frames,grayscale)
        if nargin<2
            frames = 1:o.length;
        end
        if nargin<3
            grayscale = 0;
        end
        
        nChannels = o.nChannels;
        if (grayscale), nChannels = 1; end

        % A quick memory check
        
        
       

        seq = zeros(o.height,o.width,nChannels,o.length,'uint8');
        for i=1:o.length
            im = o.frame(frames(i));
            if grayscale, im = rgb2gray(im); end
            seq(:,:,:,i) = im;
        end
    end


end % methods


end