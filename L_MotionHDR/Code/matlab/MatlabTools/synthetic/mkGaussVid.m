%% VID = MKGAUSSVID(VARARGIN)
% Generates a synthetic oscillating Gaussian. The user has full control
% over the following parameters
% dimension (160,160,1,100): Size of resulting video (hxwx1xt)
% spaceResolution (1): How many pixels to allocate to each spatial unit
% timeResolution (1): How many frames to allocate to each time unit 
% gaussianSize (3): Size of gaussian 
% gaussianCenter ([80, 80]): Where the gaussian is when it is not moving
% motionAmplitude ([1 0]): Size of motion 
% motionFrequency ([0.05 0.05]): Frequency of motion
% motionPhase (0 0): Phase of motion
function  vid  = mkGaussVid( varargin )
    p = inputParser();
    
    defaultDimension = [160, 160, 1, 100];
    defaultSize = 3;
    defaultMotionAmplitude = [1 0];
    defaultMotionFrequency = [0.05 0.05]; 
    defaultMotionPhase = [0 0]; 
    defaultCenter = [80, 80];
    defaultSpaceResolution = 1;
    defaultTimeResolution  = 1;
        
    addOptional(p, 'dimension', defaultDimension); % Increases canvas size
    addOptional(p, 'gaussianSize', defaultSize);
    addOptional(p, 'gaussianCenter', defaultCenter);
    addOptional(p, 'motionAmplitude', defaultMotionAmplitude);
    addOptional(p, 'motionFrequency', defaultMotionFrequency);
    addOptional(p, 'motionPhase', defaultMotionPhase);
    addOptional(p, 'spaceResolution', defaultSpaceResolution); % Increases space resolution 
    addOptional(p, 'timeResolution', defaultTimeResolution);   % Increases time resolution
    
    
    
    parse(p,varargin{:});
    
    dimensions = p.Results.dimension;
    gaussSize = p.Results.gaussianSize;
    gaussCenter = p.Results.gaussianCenter;
    motionAmp = p.Results.motionAmplitude;
    motionFreq = p.Results.motionFrequency;
    motionPhase = p.Results.motionPhase;
    spaceResolution = p.Results.spaceResolution;
    timeResolution = p.Results.timeResolution;
    
    spaceResolution = 1/spaceResolution;
    timeResolution = 1/timeResolution;
    
    [x,y] = meshgrid(spaceResolution:spaceResolution:dimensions(1), spaceResolution:spaceResolution:dimensions(2));
    t = timeResolution:timeResolution:dimensions(4);
    vid = zeros(size(x,1),size(x,2),1,numel(t),'single');
    
    for k = 1:numel(t)
        currentCenter = gaussCenter-motionAmp.*sin(2*pi*motionFreq*t(k)+motionPhase);
        vid(:,:,1,k) = exp(-((x-currentCenter(1)).^2+(y-currentCenter(2)).^2)./(2*gaussSize.^2));
    end    

end

