%% VID = MKGAUSSVID(VARARGIN)
% Generates a synthetic Disk blurred oscillating disk. The user has full control
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
function  vid  = mkPathDiskVid(path,  varargin )
    p = inputParser();
    
    defaultDimension = [160, 160, 1, size(path,1)];
    defaultSize = 5;
    defaultCenter = [80, 80];
    defaultBlur = 2;   
    defaultMotionNoise = 0;
        
    addOptional(p, 'dimension', defaultDimension); % Increases canvas size
    addOptional(p, 'diskSize', defaultSize);
    addOptional(p, 'diskCenter', defaultCenter);
    addOptional(p, 'diskBlur', defaultBlur);   
    addOptional(p, 'motionNoise', defaultMotionNoise);
    
    parse(p,varargin{:});
    
    dimensions = p.Results.dimension;
    diskSize = p.Results.diskSize;
    diskCenter = p.Results.diskCenter;
    diskBlur = p.Results.diskBlur;
    motionNoise = p.Results.motionNoise;
    
    
    
    [x,y] = meshgrid(1:dimensions(1), 1:dimensions(2));
    
    t = 1:dimensions(4);
    vid = zeros(size(x,1),size(x,2),1,numel(t));
    diskIm = fspecial('disk', diskSize); % Center is at diskSize+1, diskSize+1  
    diskIm = diskIm./max(diskIm(:));
    for k = 1:numel(t)
        currentCenter = diskCenter;
        v = -path(k,:);
        vx = v(1) + randn(size(x))*motionNoise;
        vy = v(2) + randn(size(x))*motionNoise;
        blurKernel = exp(-((x-currentCenter(1)).^2+(y-currentCenter(2)).^2)./(2*diskBlur.^2));
        temp = conv2(blurKernel, diskIm, 'same');
        temp = warpFL(temp, vx, vy);
        vid(:,:,1,k) = temp;
    end    

end