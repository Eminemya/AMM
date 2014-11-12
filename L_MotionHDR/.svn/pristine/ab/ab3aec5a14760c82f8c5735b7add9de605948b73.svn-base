function delta = FilterKaiser101Delay( delta,fl,fh )
    timeDimension = 3;
    len = size(delta,3);
    fl = fl*2; %Scale to be fraction of Nyquist frequency
    fh = fh*2;
    %B = fir1(min(floor(len/3),30), [fl, fh]);
    [B] = fir1(100,[fl,fh],kaiser(101,4));
    B2(1,1,:) = B;
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
    for k = 1:batches
        idx = 1+batchSize*(k-1):min(k*batchSize, M);
        temp = single(convn(double(delta(idx,:,:)), B2, 'same'));
        if (not(isempty(temp)))
            delta(idx,:,:) = temp;
        end
    end

end

