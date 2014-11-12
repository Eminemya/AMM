function delta = FilterHighpassButter( delta,fl,fh )
    timeDimension = 3;
    len = size(delta,3);
    fl = fl*2; %Scale to be fraction of Nyquist frequency
    fh = fh*2;
    %B = fir1(min(floor(len/3),30), [fl, fh]);
    [B,A] = butter(2,fl,'high');
    
    
    M = size(delta,1);
    batches = 40;    
    batchSize = ceil(M/batches);    
    for k = 1:batches
        idx = 1+batchSize*(k-1):min(k*batchSize, M);
        temp = single(FiltFiltM(B,A,double(delta(idx,:,:)),timeDimension));
        if (not(isempty(temp)))
            delta(idx,:,:) = temp;
        end
    end

end

