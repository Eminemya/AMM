%% Script to downsample video in time and space
%
% Neal Wadhwa, April 2013
function downSampleVideo( inFile, outFile, prefix)
    
    vw = VideoWriter(outFile);
    vw.Quality = 100;
    vw.FrameRate = fps;
    vw.open();
    
    [~,nF] = system(sprintf('ls %s/*.tif | wc -l', inDir));
    nF = str2num(nF);
    spaceKernel = [1 4 6 4 1]'*[1 4 6 4 1]/256;
    
    for k = 1:5
        temp = im2double(imread(fullfile(inDir, sprintf('%s%04d.tif', prefix, k))));     
        temp = rgb2ntsc(temp);
        for j = 1:3
            frames(:,:,j,k) = blurDn(temp(:,:,j));
        end
        
    end
    
    
    for k = 6:nF
        fprintf('Processing frame %d\n', k);
        odd = mod(k,2);
        frames(:,:,:,1:4) = frames(:,:,:,2:5);
        temp = im2double(imread(fullfile(inDir, sprintf('%s%04d.tif', prefix, k))));       
        temp = rgb2ntsc(temp);
        for j = 1:3
            frames(:,:,j,5) = blurDn(temp(:,:,j));
        end
        blurKer(1,1,1,:) = [1 4 6 4 1]/16;
        if (odd)
            blurredFrame =  convn(frames, blurKer,'valid');
            blurredFrame = ntsc2rgb(blurredFrame);
            for j = 1:3
                newFrame(:,:,j) = (blurredFrame(:,:,j));
            end
            vw.writeVideo(newFrame);           
        end
    end
        
        
    
    vw.close();

end

