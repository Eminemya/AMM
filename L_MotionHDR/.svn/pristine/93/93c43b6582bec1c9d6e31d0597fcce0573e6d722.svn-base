function particleList = synthSeedParticles( varargin )
    p = inputParser;

    defaultCanvasCenter = [0 0];
    defaultCanvasSize = [1 1];    
    defaultXDensity = 10;
    defaultYDensity = 10;
    
    addOptional(p, 'canvasCenter', defaultCanvasCenter);
    addOptional(p, 'canvasSize', defaultCanvasSize);
    addOptional(p, 'xDensity', defaultXDensity);
    addOptional(p, 'yDensity', defaultYDensity);
    
    parse(p, varargin{:});
    
    canvasCenter = p.Results.canvasCenter;
    canvasSize = p.Results.canvasSize;
    xdensity = p.Results.xDensity;
    ydensity = p.Results.yDensity;
    
    
    numXParticles = ceil(canvasSize(1) * xdensity);
    numYParticles = ceil(canvasSize(2) * ydensity);
    
    llim = canvasCenter-canvasSize/2;
    ulim = canvasCenter+canvasSize/2;
    
    xLocs = linspace(llim(1), ulim(1), numXParticles);
    yLocs = linspace(llim(2), ulim(2), numYParticles);
    
    count = 1;
    for k = 1:numel(xLocs)
        for j = 1:numel(yLocs)
            particleList(:,count) = [xLocs(k), yLocs(j)];
            count = count + 1;
        end
    end
  

end

