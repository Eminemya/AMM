function [vid, amp, freq, phase] = mkFourDiskModel( varargin )
    defaultDimension = [160 160 1 100];
    defaultMaxMotionAmplitude = 1; % pixel
    defaultMotionNoise = 0;
    
    p = inputParser();
    addOptional(p, 'dimension', defaultDimension);
    addOptional(p, 'maxMotion', defaultMaxMotionAmplitude);
    addOptional(p, 'motionNoise', defaultMotionNoise);
    
    parse(p, varargin{:});
    
    dimensions = p.Results.dimension;
    maxMotion = p.Results.maxMotion;
    motionNoise = p.Results.motionNoise;
    
    
    XX = dimensions(1);
    YY = dimensions(2);
    XX1 = floor(XX/4);
    XX2 = ceil(3*XX/4);
    YY1 = floor(YY/4);
    YY2 = ceil(3*YY/4);
    
    pts = [XX1 YY1; XX1 YY2; XX2 YY1; XX2 YY2];
    
    
    normalizationFactor = @(A, B) 2./A^3-2./B^3;
    inverseCDF = @(y, A,B) nthroot(1./(1./A.^3-normalizationFactor(A,B).*y./2),3);
    % Random phase, amplitude and frequency of motion
    phase = 2*pi*rand(4,2);
    amp   = rand(4,2);
    freq = inverseCDF(rand(4,2),0.01, 0.5);
    
    for k = 1:4    
        vidList{k} = mkDiskVid('diskCenter', pts(k,:), 'motionNoise', motionNoise, ...
            'motionFrequency', freq(k,:), 'motionAmplitude', amp(k,:), 'motionPhase', phase(k,:));
    end
    vid = mkMergeVid(vidList);
    vid = mkGaussNormVid(vid);


end

