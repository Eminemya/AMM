function downSampleImageCollection( inDir, outFile, prefix, fps )

    vw = VideoWriter(fullfile(inDir, outFile));
    vw.Quality = 100;
    vw.FrameRate = fps;
    vw.open();
    
    [~,nF] = system(sprintf('ls %s/*.tif | wc -l', inDir));
    nF = 483; %str2num(nF);
    spaceKernel = [1 4 6 4 1]'*[1 4 6 4 1]/256;
    
    
    
    for k = 1:nF
        fprintf('Processing frame %d\n', k);
        odd = mod(k,2);
        
        temp = im2double(imread(fullfile(inDir, sprintf('%s%04d.tif', prefix, k))));       
        temp = rgb2ntsc(temp);
        for j = 1:3
            frames(:,:,j) = blurDn(temp(:,:,j));
        end
        frames = ntsc2rgb(frames);
        vw.writeVideo(im2uint8(frames));           
    end
        
        
    
    vw.close();


end

