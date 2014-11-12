function delta = FilterButter4Delay( delta,fl,fh )
    timeDimension = 3;
    len = size(delta,3);
    fl = fl*2; %Scale to be fraction of Nyquist frequency
    fh = fh*2;
    %B = fir1(min(floor(len/3),30), [fl, fh]);
    [B,A] = butter(4,[fl,fh]);
    
    compareFreq = false;
    if (compareFreq)
       [G_pm, omega_pm] = freqz(B);
       s = zeros(len,1);
       s(ceil(fl*len/2)+1:floor(fh*len/2)) = 1;
       B2 = ifftshift(real(ifft(s)));
       [G_Id, omega_Id] = freqz(B2);
       plot(omega_Id, 2*abs(G_Id)); hold on;
       plot(omega_pm, abs(G_pm),'r');
       plot(linspace(0,pi,len), s,'g');
    end
    
    M = size(delta,1);
    batches = 40;    
    batchSize = ceil(M/batches);    
    init = zeros(size(delta(:,:,2),1), size(delta(:,:,2),2), 2);
    delay = 34;
    for k = 1:batches
        idx = 1+batchSize*(k-1):min(k*batchSize, M);
        temp = single(FilterM(B,A,double(delta(idx,:,:)), timeDimension));
        if (not(isempty(temp)))
            temp = cat(3, zeros(size(temp,1), size(temp,2), delay), temp(:,:,1:end-delay));
            delta(idx,:,:) = temp;
        end
    end

end

