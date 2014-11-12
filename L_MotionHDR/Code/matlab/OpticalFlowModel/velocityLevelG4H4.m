function [mu, V] = velocityLevelG4H4(vr, frameRange, level,  referenceFrame)
    
    if (nargin <4)
       referenceFrame = mean(im2single(vr.read(frameRange(1))),3);
    end
    thetas = [0 pi/4 pi/2 3*pi/4];
    
    im = referenceFrame;
    referencePyr = buildG4H4pyr(im, level, level, thetas);
    referencePhase = applyFunctionCell(@angle, referencePyr);
    referenceAmp = applyFunctionCell(@abs, referencePyr);
    phaseX = @(x) imag(convn(x, [0.5 0 -0.5], 'same')./(eps+x));
    phaseY = @(x) imag(convn(x, [0.5 0  -0.5]', 'same')./(eps+x));
    Sx = applyFunctionCell(phaseX, referencePyr);
    Sy = applyFunctionCell(phaseY, referencePyr);
    for l = 1:numel(Sx)
       Sx{l}(:,1) = Sx{l}(:,2);
       Sx{l}(:,end) = Sx{l}(:,end-1);
       Sx{l} = medfilt2(Sx{l}, [3 3], 'symmetric');
       
       Sy{l}(1,:) = Sy{l}(2,:);
       Sy{l}(end,:) = Sy{l}(end-1,:);
       Sy{l} = medfilt2(Sy{l}, [3 3], 'symmetric');       
       
       
    end
    tempX = mulCellArrays(Sx, referenceAmp);
    tempY = mulCellArrays(Sy, referenceAmp);
    [m, n] = size(tempX{1});
    V = zeros(2,2,size(tempX{1},1), size(tempX{1},2));
    for l = 1:numel(tempX)
        V(1,1,:,:) = V(1,1,:,:) + reshape(tempX{l}.^2, [1 1 m n]);
        V(1,2,:,:) = V(1,2,:,:) + reshape(tempX{l}.*tempY{l}, [1 1 m n]);
        V(2,2,:,:) = V(2,2,:,:) + reshape(tempY{l}.^2, [1 1 m n]);
    end
    V(2,1,:,:) = V(1,2,:,:);
    count = 1;
    mu = zeros(2,m,n,frameRange(2)-frameRange(1)+1, 'single');
    for k = frameRange(1):frameRange(2)
        fprintf('%d/%d\n', count, frameRange(2)-frameRange(1)+1);
        im = mean(im2single(vr.read(k)),3);
        currentPyr = buildG4H4pyr(im, level, level, thetas);
        currentPhase = applyFunctionCell(@angle, currentPyr);
        subPhase = subCellArrays(currentPhase, referencePhase);        
        tempT = mulCellArrays(subPhase, referenceAmp);
        E = zeros(2,1,m, n);
        for l = 1:numel(subPhase);
            E(1,1,:,:) = E(1,1,:,:) +reshape(tempX{l}.*tempT{l}, [1 1 m n]);
            E(2,1,:,:) = E(2,1,:,:) +reshape(tempY{l}.*tempT{l}, [1 1 m n]);
            %phases{l}(:,:,count) = subPhase{l};
        end
        for i = 1:m
            for j = 1:n
                mu(:,i,j,count) = V(:,:,i,j)\E(:,:,i,j);
            end
        end
        
       count = count +1;
        
    end
    mu(isnan(mu)) = 0;

end