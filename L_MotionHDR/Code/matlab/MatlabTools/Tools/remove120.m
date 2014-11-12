function  remove120( vidFile, sr,outFile )
    if (sr < 250);
        error('Sampling rate must be above 250Hz to remove 120Hz flicker');
    end
    nyquist = sr/2;
    [B,A] = butter(4, [115/nyquist, 125/nyquist],'stop');
    
    vr = VideoReader(vidFile);
    
    vw = VideoWriter(outFile);
    vw.Quality = 100;
    vw.FrameRate = vr.FrameRate;
    vw.open();            
    vid = im2double(vr.read());
    for k = 1:size(vid,4);
        vid(:,:,:,k) = rgb2ntsc(vid(:,:,:,k));        
    end
    
    vid = FiltFiltM(B,A,vid,4);
    
    for k = 1:size(vid,4);
        vid(:,:,:,k) = ntsc2rgb(vid(:,:,:,k));                        
    end
    
    vw.writeVideo(im2uint8(vid));
    vw.close();        
end

