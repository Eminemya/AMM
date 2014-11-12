%% Script to downsample video in time and space
%
% Neal Wadhwa, April 2013
function temporallyAverageVideo( inFile, outFile)

    vr =  VideoReader(inFile);
    

    vw = VideoWriter(outFile);
    vw.Quality = 90;
    vw.FrameRate = vr.FrameRate;
    vw.open();
    
    nF = vr.NumberOfFrames;   
    for k = 1:5
        temp = im2double(vr.read(k));     
        temp = rgb2ntsc(temp);
        frames(:,:,:,k) = temp;
        
    end
    
    
    for k = 6:nF
        if (mod(k,100) ==0)
            fprintf('Processing frame %d\n', k);
        end
        
        frames(:,:,:,1:4) = frames(:,:,:,2:5);
        temp = im2double(vr.read(k));       
        temp = rgb2ntsc(temp);
        frames(:,:,:,5) = temp;
        blurKer(1,1,1,:) = [1 4 6 4 1]/16;        
        blurredFrame =  convn(frames, blurKer,'valid');
        blurredFrame = ntsc2rgb(blurredFrame);        
        vw.writeVideo(im2uint8(blurredFrame));                   
    end
        
        
    
    vw.close();

end

