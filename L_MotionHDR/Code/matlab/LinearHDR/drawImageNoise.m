function out = drawImageNoise( amps, sigman)
    out = angle(eps+amps+sigman*(randn(size(amps))+1i*randn(size(amps))));    
end

