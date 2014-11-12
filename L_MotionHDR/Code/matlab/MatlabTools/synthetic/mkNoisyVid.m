function noisyVid = mkNoisyVid(inputVid, sigman)
    noisyVid = inputVid + randn(size(inputVid))*sigman;
end