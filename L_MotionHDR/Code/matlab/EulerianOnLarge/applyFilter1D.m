function out = applyFilter1D(x, tfilt)
    y(1,1,:) = x;
    out = squeeze(tfilt(y));
    

end