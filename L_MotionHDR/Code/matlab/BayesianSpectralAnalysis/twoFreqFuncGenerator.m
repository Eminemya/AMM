function [ out ] = twoFreqFuncGenerator( w, data, time)
    % model functions
    G(1,:) = cos(w(1)*time);
    G(2,:) = sin(w(1)*time);
    G(3,:) = cos(w(2)*time);
    G(4,:) = sin(w(2)*time);    
    for k = 1:4
        for j = 1:4
            M(k,j) = sum(G(k,:).*G(j,:));
        end
    end
    [V, D] = eig(M);
    H = V*G;
    
    for k = 1:4
        h(k) = sum(data.*H(k,:));
    end
    out = sum(h.^2);


end

