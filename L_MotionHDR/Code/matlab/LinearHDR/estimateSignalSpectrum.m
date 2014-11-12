function [spectrum, outName] = estimateSignalSpectrum( numDisk, ampRange, freqRange, runs )
    figDir = mfilename;
    mkdir(figDir);
    outName = sprintf('numDisks%d-ampRange%0.2f-%0.2f-freqRange%0.2f-%0.2f-runs%d.mat', ...
        numDisk, ampRange(1), ampRange(2), freqRange(1), freqRange(2), runs);
    outName = fullfile(figDir, outName);
                
     out = mkSynthPhaseRand(numDisk, ampRange, freqRange, 0, 0);
     spectrum = abs(fftn(out))./runs;
     
     parfor k = 1:runs-1
        out = mkSynthPhaseRand(numDisk, ampRange,freqRange,0,0);
        out = abs(fftn(out))./runs;
        spectrum = spectrum + out;        
     end
     save(outName, 'spectrum', 'numDisk', 'ampRange', 'freqRange', 'runs');
     
     
    
    



end

