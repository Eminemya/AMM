% Let's do a real example with only the time uncertainity
%
clear;
close all;

rootDir = '/home/nwadhwa/Downloads/Vidmag2/Data/release';
figDir = mfilename;
mkdir(figDir);
vidName = 'crane_crop.avi';
orientations = 4;
%% Measure noise
vr = VideoReader(fullfile(rootDir, vidName));
vw = VideoWriter(fullfile(figDir, 'crane_out.avi'));
vw.Quality = 90;
vw.FrameRate = vr.FrameRate;
vw.open();

vwO = VideoWriter(fullfile(figDir, 'crane_original.avi'));
vwO.Quality = 90;
vwO.open();

xIDX = 1:100;
yIDX = 1:100;
vid = vr.read();
vid = mean(im2single(vid(yIDX, xIDX,:,:)),3);
noiseSigmas = sqrt(var(vid,1,4));
noiseSigma = (mean(noiseSigmas(:)));
exaggerationFactor = 1.5; % Maybe to compensate for model?
noiseSigma = noiseSigma*exaggerationFactor;

% Test
frame =mean(vid,4);
VVV = bsxfun(@plus, noiseSigma*randn(100,100,1,215),frame);
%implay(cat(2,vid,VVV)) %I guess it is comparable

predictedRatio = predictedSigmaOct4(vr.Height, vr.Width, orientations);

%% Get Phase Signal
% The goal will be to regularize across each set of orientations,
% independent of scale
alpha = 50;
[B,A] = butter(1,[0.2 0.4]/12);
ht = maxSCFpyrHt(rgb2gray(vr.read(1)));
[buildPyr, reconPyr] = octave4PyrFunctions(vr.Height, vr.Width);

[referencePyr, pind] =  buildPyr(mean(im2single(vr.read(1)), 3));
% Spatial derivative of refernecePyr
for k = 2:size(pind,1)-1
    currentBand = pyrBand(referencePyr,pind, k);
    Sx{k} = imag(convn(currentBand,[ 1 -1],'same')./(eps+currentBand));
    Sy{k} = imag(convn(currentBand,[ 1 -1]','same')./(eps+currentBand));    
end
warning('off');
for j = 1:ht
    muChange0{j} = zeros([2, pind(2+(j-1)*orientations,:)],'single');
    muChange1{j} = zeros([2, pind(2+(j-1)*orientations,:)],'single');
end
for j = 2:size(pind,1)-1
   phaseChange0{j} = zeros(pind(j,:), 'single'); 
   phaseChange1{j} = zeros(pind(j,:), 'single'); 
end

for k = 2:vr.NumberOfFrames    
    k
   pyr = buildPyr(mean(im2single(vr.read(k)), 3));
   outPyr = zeros(size(pyr), 'single');
   outPyrO = zeros(size(pyr), 'single');
   for j = 1:ht
      bandIDX = 1+(j-1)*(orientations) +(1:orientations);
      % Al orientations in a scale
      sampleBand = pyrBand(pyr, pind, bandIDX(1));
      V = zeros(2,2,size(sampleBand,1), size(sampleBand,2),'single');
      E = zeros(2,1, size(sampleBand,1), size(sampleBand,2),'single');
      for l = bandIDX
         phaseDiff{l} = mod(pi+angle(pyrBand(pyr, pind, l))-angle(pyrBand(referencePyr,pind,l)),2*pi)-pi;   
         % temporal filter phase Diff for comparison
         phaseFiltered{l} = B(1)*phaseDiff{l} + phaseChange0{l};
         phaseChange0{l} = B(2) * phaseDiff{l} + phaseChange1{l} - A(2) * phaseFiltered{l};
         phaseChange1{l} = B(3) * phaseDiff{l}                   - A(3) * phaseFiltered{l};
         
         %
         levelAmp{l} = abs(pyrBand(pyr,pind,l));
         phit_SD{l}  = predictedRatio(l)*noiseSigma./levelAmp{l};
         temp1X{l} = Sx{l}./phit_SD{l};
         temp1Y{l} = Sy{l}./phit_SD{l};
         temp2{l} = phaseDiff{l}./phit_SD{l};
         % Precision matrix
         V(1,1,:,:) = V(1,1,:,:) + reshape(temp1X{l}.^2, [1,1, size(V,3), size(V,4)]);
         V(2,2,:,:) = V(2,2,:,:) + reshape(temp1Y{l}.^2,[1,1, size(V,3), size(V,4)]);
         V(1,2,:,:) = V(1,2,:,:) + reshape(temp1X{l}.*temp1Y{l}, [1,1, size(V,3), size(V,4)]);
         E(1,1,:,:) = E(1,1,:,:) + reshape(temp2{l}.*temp1X{l}, [1,1, size(V,3), size(V,4)]);
         E(2,1,:,:) = E(2,1,:,:) + reshape(temp2{l}.*temp1Y{l},[1,1, size(V,3), size(V,4)]);
         
      end
      V(2,1,:,:) = V(1,2,:,:);
      mu{j} = zeros(2,size(sampleBand,1), size(sampleBand,2),'single');      
      for m = 1:size(V,3)
          for n = 1:size(V,4)
            mu{j}(:,m,n) = V(:,:,m,n)\E(:,:,m,n);
          end
      end
      mu{j}(isnan(mu{j})) = 0;
      % Temporal filter mu
      muFiltered{j} = B(1) * mu{j} + muChange0{j};
      muChange0{j} = B(2) * mu{j} + muChange1{j} - A(2) * muFiltered{j};
      muChange1{j} = B(3) * mu{j}                - A(3) * muFiltered{j};
      
      
      
      % Convert back to phase changes, amplify
      for l = bandIDX;
          idx = pyrBandIndices(pind, l);
          phaseDiff2 = squeeze(muFiltered{j}(1,:,:)).*Sx{l}+squeeze(muFiltered{j}(2,:,:)).*Sy{l};
          outPyr(idx) = pyr(idx).*exp(1i*alpha*phaseDiff2(:));          
          outPyrO(idx) = pyr(idx).*exp(1i*alpha*phaseFiltered{l}(:));
      end
      
     
      % 
      
   end
   idx = pyrBandIndices(pind, size(pind,1));
   outPyr(idx) = pyr(idx);
   outPyrO(idx) = pyr(idx);
   % Collapse pyr and write to file
   outFrame = reconPyr(outPyr ,pind);
   vw.writeVideo(im2uint8(outFrame));
   outFrame = reconPyr(outPyrO ,pind);
   vwO.writeVideo(im2uint8(outFrame));
   
end

vwO.close();
vw.close();

vidgridMJPEG({fullfile(figDir, 'crane_out.avi'), fullfile(figDir, 'crane_original.avi')}, {'Regularized across orientations', 'nothign'}, fullfile(figDir, 'crane_compare.avi'));

%% Other vis
vr = VideoReader(fullfile(figDir, 'crane_out.avi'));
vid1 = mean(im2single(vr.read()),3);
vr = VideoReader(fullfile(figDir, 'crane_original.avi'));
vid2 = mean(im2single(vr.read()),3);
out = cat(3,vid1,vid2,zeros(size(vid2)));
implay(out);



