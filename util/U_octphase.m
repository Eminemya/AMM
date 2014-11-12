function [ buildPyr, reconPyr ] = U_octphase( h,w,num_or)
    ht = maxSCFpyrHt(zeros(h,w));
    filters = getFilters([h w], 2.^[0:-1:-ht], num_or);
    [croppedFilters, filtIDX] = getFilterIDX(filters);
    buildPyr = @(im) buildSCFpyrGen(im, croppedFilters, filtIDX) ;
    reconPyr = @(pyr, pind) reconSCFpyrGen(pyr, pind, croppedFilters, filtIDX);
end
