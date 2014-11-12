function [ outPath ] = renderResampleParticleList( particleListPath, rateIn, rateOut )
    temp = resample(particleListPath(:,1,1),rateOut,rateIn);
    outPath = zeros(numel(temp), size(particleListPath,2), size(particleListPath,3));
    for k = 1:size(particleListPath,2)
        for j = 1:size(particleListPath,3)
            outPath(:,k,j) = resample(particleListPath(:,k,j), rateOut, rateIn);
        end
    end

end

