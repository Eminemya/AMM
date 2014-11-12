function cellVid = pyrVid2CellVid(pyrVid, pind )
    numBands = size(pind,1);
    nF = size(pyrVid, 2);
    cellVid = cell(numBands, 1);


    for k = 1:numBands
        idx = pyrBandIndices(pind, k);
        cellVid{k} = reshape(pyrVid(idx,:), [pind(k,1), pind(k,2), 1, nF]);
    end

end

