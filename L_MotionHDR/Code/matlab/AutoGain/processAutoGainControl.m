%% Uses CSP, Uses maxPix as alpha, supposed ot be similar to previous

function [ outName ] = processAutoGainControl( vidFile, maxPix, sigma, fl, fh, fs, figDir, frameRange)
    [~, vidName, ext] = fileparts(vidFile);
    if (strcmp(ext, '.cine'))
       vr = CineReader(vidFile);        
    else
       vr = VideoReader(vidFile); 
    end
    if (nargin < 8)
       frameRange= [1 vr.NumberOfFrames]; 
    end
    vid = rgb2y(im2single(vr.read([frameRange(1), frameRange(2)])));
    [h,w,nC,nF] = size(vid);
    ns = fs/2;
    for k = 1:nF
       % Compute phases
       [pyr(:,k), pind] = buildSCFpyr(vid(:,:,1,k));
    end
   % Temporal Filtering
   [B,A] = butter(2,[fl, fh]/ns);
   phases = angle(pyr); % Sub first frame
   phases = mod(pi+bsxfun(@minus, phases, phases(:,1)),2*pi)-pi;
   phases = FilterM(B,A, phases,2);
   
   % Spatial Smoothing      
   kernel = fspecial('gaussian', ceil(4*sigma), sigma);
   for k = 1:nF
       amp = abs(pyr(:,k));
       for band = 2:size(pind,1)-1
           currentBand = pyrBand(phases(:,k),pind,band);
           currentAmp = pyrBand(amp, pind, band);
           idx = pyrBandIndices(pind,band);
           smoothedBand = imfilter(currentBand.*currentAmp, kernel)./(eps+imfilter(currentAmp, kernel));
           phases(idx,k) = smoothedBand(:);           
       end
   end
   % Remove phase change in residual levels
   ht = size(pind,1);
   idx = pyrBandIndices(pind,1);
   phases(idx,:) = 0;
   idx = pyrBandIndices(pind,ht);
   phases(idx,:) = 0;
   
   
   
   
   orientations = 1;
   while (all(pind(1,:) == pind(orientations,:)))
       orientations = orientations + 1;
   end
   orientations = orientations - 2;
   scales = (ht-2)/orientations;
   % Amplification
   maxPixLevels = zeros(ht,1);
   for k = 1:scales
       for j = 1:orientations
            bandIDX = 1+(k-1)*orientations+j;
            maxPixLevels(bandIDX) = maxPix/2^(k-1);            
       end
   end
   for l = 2:ht-1
      idx = pyrBandIndices(pind, l);
      %timeAmplitude = abs((phases(idx,:)));
      alpha = maxPix;
      phases(idx,:) = phases(idx,:).*alpha;
   end   
   %% Reonstruction
   vid = vr.read([frameRange(1) frameRange(2)]);
   
   for k = 1:nF
       temp = rgb2ntsc(im2single(vid(:,:,:,k)));
       outluma=  (reconSCFpyr(pyr(:,k).*exp(1i*phases(:,k)), pind));
       temp(:,:,1) = outluma;
       vid(:,:,:,k) = im2uint8(ntsc2rgb(temp)); 
   end
   outName = fullfile(figDir, sprintf('%s-maxPix%0.1f-band%0.1f-%0.1f-fs%0.1f-sigma%0.1f-range%d-%d.avi', vidName, maxPix, fl, fh, fs, sigma, frameRange(1), frameRange(2)));
   writeVideo(vid, vr.FrameRate, outName);
   
   

end

