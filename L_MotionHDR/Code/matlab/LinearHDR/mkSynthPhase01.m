
%% VID = MKGAUSSVID(VARARGIN)
% Generates a synthetic Gaussian blurred oscillating disk. The user has full control
% over the following parameters
% dimension (160,160,1,100): Size of resulting video (hxwx1xt)
% spaceResolution (1): How many pixels to allocate to each spatial unit
% timeResolution (1): How many frames to allocate to each time unit 
% diskSize (5): Radius of disk 
% diskBlur (2): Size of Gaussian blur applied to disk
% diskCenter ([80, 80]): Where the disk is when it is not moving
% motionAmplitude ([1 0]): Size of motion 
% motionFrequency ([0.05 0.05]): Frequency of motion
% motionPhase (0 0): Phase of motion
% motionNoise (0): spatiotemporal Gaussian noise added to motion signal
function  [vid, amp]  = GenerateSamplesFromDistribution( varargin )
    p = inputParser();
    
    defaultDimension = [160, 160, 1, 100];
    defaultSize = 5;    
    defaultCenter = [80,80];
    defaultBlur = 2;
    defaultNumberDisks = 5;
    
    defaultMotionAmplitude = 0.1;
    defaultMotionFrequency = 0.05;
    defaultMotionPhase = 0; 
    defaultMotionNoise = 0;
    defaultImageNoise = 0;
    
    defaultSpaceResolution = 1;
    defaultTimeResolution  = 1;
        
    addOptional(p, 'dimension', defaultDimension); % Increases canvas size
    addOptional(p, 'diskSize', defaultSize);
    addOptional(p, 'diskCenter', defaultCenter);
    addOptional(p, 'diskBlur', defaultBlur);
    addOptional(p, 'motionAmplitude', defaultMotionAmplitude);
    addOptional(p, 'motionFrequency', defaultMotionFrequency);
    addOptional(p, 'motionPhase', defaultMotionPhase);
    addOptional(p, 'motionNoise', defaultMotionNoise);
    addOptional(p, 'imageNoise', defaultImageNoise);
    
    parse(p,varargin{:});
    
    dimensions = p.Results.dimension;
    diskSize = p.Results.diskSize;
    diskCenter = p.Results.diskCenter;
    diskBlur = p.Results.diskBlur;
    motionAmp = p.Results.motionAmplitude;
    motionFreq = p.Results.motionFrequency;
    motionPhase = p.Results.motionPhase;
    motionNoise = p.Results.motionNoise;
    imageNoise = p.Results.imageNoise;

    [x,y] = meshgrid(1:dimensions(1), 1:dimensions(2));
    
    t = 1:dimensions(4);
    
    
    vid = zeros(size(x,1),size(x,2),1,numel(t));
    diskIm = fspecial('disk', diskSize); % Center is at diskSize+1, diskSize+1  
    diskIm = diskIm./max(diskIm(:));
   
    currentCenter = diskCenter;    
    blurKernel = exp(-((x-currentCenter(1)).^2+(y-currentCenter(2)).^2)./(2*diskBlur.^2));
    temp = conv2(blurKernel, diskIm, 'same');
    temp = temp./max(temp(:));
    amp = temp;
     for k = 1:numel(t)   
        v = motionAmp.*sin(2*pi*motionFreq*t(k)+motionPhase);        
        vid(:,:,1,k) = temp.*v + randn(dimensions(1:2))*motionNoise + drawImageNoise(amp, imageNoise);                
    end                
end