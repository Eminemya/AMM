function delta = FilterWeiner01( delta,fl,n )
    timeDimension = 3;
    len = size(delta,3);
    fl = fl*2; %Scale to be fraction of Nyquist frequency
    
    %B = fir1(min(floor(len/3),30), [fl, fh]);
    [B,A] = butter(2,fl, 'high');
    

    M = size(delta,1);
    batches = 40;    
    batchSize = ceil(M/batches);    
    for k = 1:batches
        idx = 1+batchSize*(k-1):min(k*batchSize, M);
        temp = double(delta(idx,:,:));
        temp = single(FiltFiltM(B,A,temp, timeDimension));
        % Weiner Filter - Auto Correlation up from 1:n+1
        if (not(isempty(temp)))
            R = zeros(size(temp,1), size(temp,2), n+1,'single');
            for lag = 0:n
               R(:,:,lag+1) = mean(temp(:,:,1:end-lag).*temp(:,:,lag+1:end),3);
            end
            [XX, YY] = meshgrid(0:n-1, 0:n-1);
            idx1 = abs(XX-YY)+1;            
            idx2 = [2:n+1];
            for i = 1:size(R,1)
                for j = 1:size(R,2)
                    currentLine = squeeze(R(i,j,:));
                    T = currentLine(idx1);
                    L = currentLine(idx2);
                    w = T\L;
                    temp(i,j,:) = filter(w,1,squeeze(temp(i,j,:)));
                end
            end                        
            delta(idx,:,:) = temp;
        end
    end
    
    %% Weiner Filtering
    
    

end

