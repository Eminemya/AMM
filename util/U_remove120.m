function  vid=U_remove120( vid, fl,fh,sr )
    if (sr < 250);
        error('Sampling rate must be above 250Hz to remove 120Hz flicker');
    end
    nyquist = sr/2;
    [B,A] = butter(4, [fl/nyquist, fh/nyquist],'stop');
           
    vid = im2double(vid);
    for k = 1:size(vid,4);
        vid(:,:,:,k) = rgb2ntsc(vid(:,:,:,k));        
    end
    
    vid = FiltFiltM(B,A,vid,4);
    
    for k = 1:size(vid,4);
        vid(:,:,:,k) = ntsc2rgb(vid(:,:,:,k));                        
    end
           
end

