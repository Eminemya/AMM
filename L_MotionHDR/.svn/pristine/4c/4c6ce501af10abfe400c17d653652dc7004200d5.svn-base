function [ out ] = renderParticleListPath(particleListPath, rateIn, rateOut, varargin )
    particleListPath = renderResampleParticleList(particleListPath, rateIn, rateOut);
    temp = renderParticleList(squeeze(particleListPath(1,:,:)), varargin{:});
    
    out = zeros(size(temp,1),size(temp,2), 1, size(particleListPath,1));
    
    for k = 1:size(particleListPath,1)
        k
        out(:,:,1,k) = renderParticleList(squeeze(particleListPath(k,:,:)), varargin{:});
    end

end