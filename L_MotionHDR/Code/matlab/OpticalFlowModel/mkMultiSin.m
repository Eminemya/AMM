function [out, alone] = mkMultiSin(N, wx, wy, p)
    if(nargin <4)
        p = zeros(numel(wx),1);
    end
    
    alone = zeros(N,N,numel(wx));
    for j = 1:numel(wx)
       alone(:,:,j) =  mkSin(N, wx(j), wy(j), p(j));       
    end
    out = sum(alone,3);
end