function [out, amp, mLoc, mAmp, mFreq, mPhase] =  mkSynthPhaseRand( numDisks, ampRange, freqRange, motionNoise, imageNoise)
    mAmp = rand(numDisks,1)*(ampRange(2)-ampRange(1))+ampRange(1);
    mFreq = rand(numDisks,1)*(freqRange(2)-freqRange(1))+freqRange(1);
    mPhase = rand(numDisks,1)*2*pi;
    mLoc = ceil(rand(numDisks,2)*160);
    
    amp = zeros(160,160,numDisks);
    for k = 1:numDisks
       [vidList{k}, amp(:,:,k)] = mkSynthPhase01('motionAmplitude', mAmp(k), ...
        'motionFrequency', mFreq(k), 'motionPhase', mPhase(k),...
            'diskCenter', mLoc(k,:));
    end
    amp = max(amp, [], 3);
    out = mkMergeVid(vidList);
    out = mkImageNoise(out, amp, imageNoise);
    out = mkMotionNoise(out, motionNoise);

end

