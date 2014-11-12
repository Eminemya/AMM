%% Doesn't do anything, just copies files

function [ outName ] = processAutoGainOriginal( vidFile, maxPix, sigma, fl, fh, fs, figDir, frameRange)   
    [~, vidName, ext] = fileparts(vidFile);
   outName = fullfile(figDir, [vidName ext]);
   copyfile(vidFile, outName);
   
   

end

