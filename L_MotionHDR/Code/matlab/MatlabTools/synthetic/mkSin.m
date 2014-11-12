function out = mkSin(N, wx, wy,p)
    if(nargin <4)
        p = 0;
    end
    dims = [N, N];
    ctr = ceil(dims+0.5);        
    [x,y] = meshgrid(((1:dims(2))-ctr(2))./(dims(2)/2), ((1:dims(2))-ctr(2))./(dims(2)/2));
    out = sin(pi*wx*x+pi*wy*y+p);
end