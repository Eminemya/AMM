function [ predictedRatios ] = predictedSigmaOct4( h,w,orientations )

    ht = maxSCFpyrHt(zeros(h,w));
    filters = getFilters([h w], 2.^[0:-1:-ht], orientations);
    [croppedFilters, filtIDX] = getFilterIDX(filters);
       C = real((ifft2(fftshift(croppedFilters{2}))));
       predictedRatios(2) = sqrt(sum(C(:).^2));
    for l = 3:numel(croppedFilters)-1
        predictedRatios(l) = predictedRatios(2)*numel(croppedFilters{2})./numel(croppedFilters{l});
    end

end

