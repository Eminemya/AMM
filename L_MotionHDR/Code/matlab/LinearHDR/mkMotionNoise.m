function [ vid ] = mkMotionNoise( vid, motionNoise )
    vid = vid + motionNoise*randn(size(vid));    
end

