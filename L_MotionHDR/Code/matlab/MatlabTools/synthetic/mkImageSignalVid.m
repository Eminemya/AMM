%% VID = MKGAUSSVID(IMAGE, SIGNAL)
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
function  vid  = mkImageSignalVid(inputImage, inputSignal, varargin )  
    p = inputParser();
    dimensions = [size(inputImage,1), size(inputImage,2), size(inputImage,3), size(inputSignal,1)];                  
    
    defaultSize = 5;
    defaultCenter = ceil((dimensions(1:2)+0.5)/2);
    defaultBlur = 2;
    
    
    addOptional(p, 'diskSize', defaultSize);
    addOptional(p, 'diskCenter', defaultCenter);
    addOptional(p, 'diskBlur', defaultBlur);
    
    parse(p, varargin{:});
    diskSize = p.Results.diskSize;
    diskCenter = p.Results.diskCenter;
    diskBlur = p.Results.diskBlur;
    
    
    [x,y] = meshgrid(1:dimensions(2), 1:dimensions(1));
        
    vid = zeros(dimensions);
        
    for k = 1:dimensions(4)
       k
        currentCenter = diskCenter;        
        vx = inputSignal(k,1); 
        vy = inputSignal(k,2);
        blurKernel = exp(-((x-currentCenter(1)).^2+(y-currentCenter(2)).^2)./(2*diskBlur.^2));
        blurKernel = blurKernel./sum(blurKernel(:));
        temp = conv2(blurKernel, inputImage, 'same');
        temp = warpFL(temp, vx, vy);
        vid(:,:,:,k) = temp;
    end    

end

