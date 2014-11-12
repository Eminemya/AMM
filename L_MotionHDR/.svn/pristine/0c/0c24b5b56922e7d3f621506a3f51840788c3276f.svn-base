classdef MyVideoWriter < handle
    
    
properties (Constant)
    VID_FILE = 0
    VID_SEQ = 1 
    
    COMPRESSION_NONE = 0
    COMPRESSION_JPEG = 1
end

properties (SetAccess = private)
    vidType;
    compression;
    path;
    format;
    vidObj;
    frameNum;
end    
   
methods
    
    function o = MyVideoWriter(fileName,compression,frameRate)
        if exist('compression','var')~=1 || isempty(compression)
            compression = MyVideoWriter.COMPRESSION_NONE;
        end
        if exist('frameRate','var')~=1 || isempty(frameRate)
            frameRate = 30;
        end
        
        [~,~,ext] = fileparts(fileName);
        if ~isempty(ext)
            o.vidType = MyVideoWriter.VID_FILE;
            % TODO: handle format
        else
            o.vidType = MyVideoWriter.VID_SEQ;
        end

        o.path = fullpath(fileName);
        o.compression = compression;

        %--- Video file
        if o.vidType == MyVideoWriter.VID_FILE
            switch compression
                case MyVideoWriter.COMPRESSION_NONE
                    o.vidObj = VideoWriter(fileName,'Uncompressed AVI');
                case MyVideoWriter.COMPRESSION_JPEG
                    o.vidObj = VideoWriter(fileName,'Motion JPEG AVI');
                    o.vidObj.Quality = 100; % TODO: export
                otherwise
                    % TODO
            end
            o.vidObj.FrameRate = frameRate;
            open(o.vidObj);
        
        %--- Video sequence
        elseif o.vidType == MyVideoWriter.VID_SEQ
            mkdir(o.fileName);
            o.frameNum = 0;
        end
    end
    
    function delete(o)
        o.close;
    end
    
    function o = append(o,frame)
        if o.vidType==MyVideoWriter.VID_FILE
            writeVideo(o.vidObj,frame);
        elseif o.vidType==MyVideoWriter.VID_SEQ
            if o.compressionType==MyVideoWriter.COMPRESSION_NONE
                format = 'png';
            elseif o.compressionType==MyVideoWriter.COMPRESSION_JPEG
                format = 'jpg';
            end
            imwrite(frame,fullfile(o.path,sprintf('%06d.%s',o.frameNum,format)));
            o.frameNum=o.frameNum+1;
        end
    end
    
    function o = close(o)
        close(o.vidObj);
    end
    
end
    
end