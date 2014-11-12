function out = concatVidsH( vids, border )
    if (nargin <2)
        border = 0;
    end
    H = max(cellfun(@(x) size(x,1), vids));
    W = sum(cellfun(@(x) size(x,2), vids)) + border*(numel(vids)-1);
    C = max(cellfun(@(x) size(x,3), vids));
    T = max(cellfun(@(x) size(x,4), vids));
    out = zeros(H,W,C,T);
    curW = 0;
    for k = 1:numel(vids)
       [h,w,nC,nF] = size(vids{k});
       out(1:h,(1:w)+curW, 1:nC, 1:nF) = vids{k};
       curW = curW + w + border;
    end
    
    

end

