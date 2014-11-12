%% Handles multiple scales
% takes in two frames, to see what disagreement looks like
function [ covMats,V, mu, postProb, Sx, Sy, St, phit_SD] = frameToCov003( video, noiseSigma, bands, frames, buildPyr, predictedRatio)
    if(or(isa(video, 'VideoReader'), isa(video, 'CineReader')))
        vr = video;
    else
        [~,~,ext] =fileparts(video);
       if (strcmp(ext, '.cine'))
          vr = CineReader(video); 
       else
           vr = VideoReader(video);
       end           
    end
    
    frame = mean(im2single(vr.read(frames(1))),3);
    frame2 = mean(im2single(vr.read(frames(2))),3);
    if (nargin < 5)
        orientations = 4;
        [buildPyr,~] = octave4PyrFunctions(size(frame,1), size(frame,2));
        predictedRatio =  predictedSigmaOct4(vr.Height, vr.Width, orientations);
    end
    

    [pyr, pind] = buildPyr(frame);
    pyr2 = buildPyr(frame2);
    
    bandIDX = bands;
    sampleBand = pyrBand(pyr, pind, 2);
    h = size(sampleBand,1);
    w = size(sampleBand,2); 
    V = zeros(2,2,h, w,'single'); % Precision matrix
    E = zeros(2,1,h, w,'single'); % Precision matrix
    
    %
    
    for l = 1:numel(bandIDX)
        currentBand = pyrBand(pyr,pind, bandIDX(l));
        currentBand2 = pyrBand(pyr2,pind, bandIDX(l));
        Sx{l} = imag(convn(currentBand,[ 1 -1],'same')./(eps+currentBand));
        Sy{l} = imag(convn(currentBand,[ 1 -1]','same')./(eps+currentBand));    
        
         levelAmp{l} = abs(currentBand);
         phit_SD{l}  = predictedRatio(bandIDX(l))*noiseSigma./levelAmp{l};
         temp1X{l} = Sx{l}./phit_SD{l};
         temp1Y{l} = Sy{l}./phit_SD{l};
         St{l} = mod(pi+angle(currentBand2)-angle(currentBand),2*pi)-pi;
         temp1T{l} = St{l}./phit_SD{l};
         % Resize         
         temp1X{l} = imresize(temp1X{l}, [h,w], 'lanczos3');
         temp1Y{l} = imresize(temp1Y{l}, [h, w], 'lanczos3');
         temp1T{l} = imresize(temp1T{l}, [h, w], 'lanczos3');
         
         Sx{l} = imresize(Sx{l}, [h, w] , 'lanczos3');
         Sy{l} = imresize(Sy{l}, [h, w] , 'lanczos3');
         St{l} = imresize(St{l}, [h, w], 'lanczos3');
         phit_SD{l} = imresize(phit_SD{l}, [h, w] , 'lanczos3');
         
         % Precision matrix
         V(1,1,:,:) = V(1,1,:,:) + reshape(temp1X{l}.^2, [1,1, size(V,3), size(V,4)]);
         V(2,2,:,:) = V(2,2,:,:) + reshape(temp1Y{l}.^2,[1,1, size(V,3), size(V,4)]);
         V(1,2,:,:) = V(1,2,:,:) + reshape(temp1X{l}.*temp1Y{l}, [1,1, size(V,3), size(V,4)]);
         E(1,1,:,:) =  E(1,1,:,:) + reshape(temp1T{l}.*temp1X{l}, [1 1 , size(E,3), size(E,4)]);
         E(2,1,:,:) =  E(2,1,:,:) + reshape(temp1T{l}.*temp1Y{l}, [1 1 , size(E,3), size(E,4)]);
    end
    V(2,1,:,:) = V(1,2,:,:);
    warning('off');    
    postProb =zeros(numel(bands), h,w,'single');
    mu = zeros(2,1,h,w,'single');
    det = 1./(V(1,1,:,:).*V(2,2,:,:)-V(1,2,:,:).^2);
    mu(1,1,:,:) = (V(2,2,:,:).*E(1,1,:,:)-V(1,2,:,:).*E(2,1,:,:)).*det;
    mu(2,1,:,:) = (-V(1,2,:,:).*E(1,1,:,:)+V(1,1,:,:).*E(2,1,:,:)).*det;
%{
    for j = 1:size(V,3)
        for k = 1:size(V,4)
            mu(:,:,j,k) = V(:,:,j,k)\E(:,:,j,k);
            
        end
    end
%}
    for l = 1:numel(bandIDX)        
       %postProb(l,:,:) = 1./(sqrt(2*pi)*phit_SD{l}).*exp(-(Sx{l}.*squeeze(mu(1,1,:,:))+Sy{l}.*squeeze(mu(2,1,:,:))-temp1T{l}).^2./(2*phit_SD{l}.^2));
       postProb(l,:,:) = abs(Sx{l}.*squeeze(mu(1,1,:,:))+Sy{l}.*squeeze(mu(2,1,:,:))-St{l})./(phit_SD{l});
    end
    covMats =0 ;
end

