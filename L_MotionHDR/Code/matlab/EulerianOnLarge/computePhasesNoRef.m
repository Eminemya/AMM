function [ phases, pyrs, pind ] = computePhasesNoRef( vid, buildPyr )
if (nargin<3)
    refFrame = 1;
end

    [refPyr, pind] = buildPyr(vid(:,:,1,refFrame));
    [~, ~, ~, nF] = size(vid);

    pyrs = zeros(numel(refPyr), nF, 'single');
    phases = zeros(numel(refPyr), nF, 'single');

    for k = 1:nF
       pyr = buildPyr(vid(:,:,1,k));
       phases(:,k) = angle(pyr);
       pyrs(:,k) = pyr;
    end
    %pyrs= 0;


end

