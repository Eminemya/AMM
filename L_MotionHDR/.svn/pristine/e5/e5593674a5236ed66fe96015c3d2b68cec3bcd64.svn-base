%% Handles multiple scales

function [ covMats,V ] = frameToCov002( video, noiseSigma, bands, buildPyr, predictedRatio)
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
    frame = mean(im2single(vr.read(1)),3);
%    [buildPyr,~] = octave4PyrFunctions(size(frame,1), size(frame,2));
    [pyr, pind] = buildPyr(frame);
    scale = 1;
    orientations = 4;
    bandIDX = bands;
    sampleBand = pyrBand(pyr, pind, 2);
    h = size(sampleBand,1);
    w = size(sampleBand,2); 
    V = zeros(2,2,h, w,'single'); % Precision matrix
    %predictedRatio =  predictedSigmaOct4(vr.Height, vr.Width, orientations);
    
    for l = 1:numel(bandIDX)
        currentBand = pyrBand(pyr,pind, bandIDX(l));
        Sx{l} = imag(convn(currentBand,[ 1 -1],'same')./(eps+currentBand));
        Sy{l} = imag(convn(currentBand,[ 1 -1]','same')./(eps+currentBand));    
        
         levelAmp{l} = abs(currentBand);
         phit_SD{l}  = predictedRatio(bandIDX(l))*noiseSigma./levelAmp{l};
         temp1X{l} = Sx{l}./phit_SD{l};
         temp1Y{l} = Sy{l}./phit_SD{l};
         % Resize         
         temp1X{l} = imresize(temp1X{l}, [h,w], 'lanczos3');
         temp1Y{l} = imresize(temp1Y{l}, [h, w], 'lanczos3');
         
         % Precision matrix
         V(1,1,:,:) = V(1,1,:,:) + reshape(temp1X{l}.^2, [1,1, size(V,3), size(V,4)]);
         V(2,2,:,:) = V(2,2,:,:) + reshape(temp1Y{l}.^2,[1,1, size(V,3), size(V,4)]);
         V(1,2,:,:) = V(1,2,:,:) + reshape(temp1X{l}.*temp1Y{l}, [1,1, size(V,3), size(V,4)]);
    end
    V(2,1,:,:) = V(1,2,:,:);
    warning('off');
    %{
    for j = 1:size(V,3)
        for k = 1:size(V,4)
            covMats(:,:,j,k) = inv(V(:,:,j,k));
        end
    end
    %}
    covMats =0 ;
end

