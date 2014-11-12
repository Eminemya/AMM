%% Automtically chose the time sigma

function delta = FilterAccel02( delta,sigma, fh )

    
    kernel(1,1,:) = [-1 2 -1];

    N = ceil(3*sigma);
    if (sigma ~=0)
        gaussKernel = exp(-(-N:N).^2./(2*sigma.^2));
        gaussKernel = gaussKernel./sum(gaussKernel);
        gaussKernelT(1,1,:) = gaussKernel;
    else
        gaussKernelT(1,1,1) = 1;
    end
        
    M = size(delta,1);
    batches = 40;    
    batchSize = ceil(M/batches);    
    len = size(delta, 3);
    winSize = 32;
    halfWinSize  = winSize/2;
    
    WWtemp = sin(linspace(0, pi/2, halfWinSize));
    WWW(1,1,:) = WWtemp;
    
    
    for k = 1:batches
        idx = 1+batchSize*(k-1):min(k*batchSize, M);
        temp = delta(idx,:,:);
        for j = halfWinSize:len-halfWinSize
            spec = abs(fft(temp(:,:,j-halfWinSize+1:j+halfWinSize)));
            spec = spec(1:halfWinSize);
            spec = bsxfun(@times, spec, WWW);
            [~, I] = max(spec);
            sigma = 2*pi/I;
            
            
        end
        
        
        temp = convn(delta(idx,:,:), kernel, 'valid');
        temp1 = zeros(size(delta(idx,:,:)));
        temp1(:,:,2:end-1) = temp;
        temp1 = convn(temp1, gaussKernelT, 'same');
        if (not(isempty(temp1)))
            delta(idx,:,:) = temp1;
        end
    end

end

