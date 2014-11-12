function delta = FilterAccelFreq( delta,fl, fh )
    timeDimension = 3;
    len = size(delta,3);

    
    kernel(1,1,:) = [-1 2 -1];


        
    M = size(delta,1);
    batches = 40;    
    batchSize = ceil(M/batches);    
    [B, A] = butter(2, [fl, fh]);
    
    for k = 1:batches
        idx = 1+batchSize*(k-1):min(k*batchSize, M);
        temp = convn(delta(idx,:,:), kernel, 'valid');
        temp1 = zeros(size(delta(idx,:,:)));
        temp1(:,:,2:end-1) = temp;
        
        temp1 = FiltFiltM(B,A, temp1, timeDimension);        
        if (not(isempty(temp1)))
            delta(idx,:,:) = temp1;
        end
    end

end

