function [ out ] = renderParticleList(particleList, varargin )
       p = inputParser;

       defaultFGColor = [1 1 1];
       defaultBGColor = [0 0 0];
       defaultParticleSize = 0.01; %units
       defaultViewCenter = [ 0 0];
       defaultViewSize   = [1 1];
       defaultPxHeight = 200;
              
       addOptional(p, 'foregroundColor', defaultFGColor);
       addOptional(p, 'backgroundColor', defaultBGColor);
       addOptional(p, 'particleSize', defaultParticleSize);
       addOptional(p, 'viewCenter', defaultViewCenter);
       addOptional(p, 'viewSize', defaultViewSize);
       addOptional(p, 'pixelHeight', defaultPxHeight);
       
       parse(p, varargin{:});
       
       
       fgColor = p.Results.foregroundColor;
       bgColor = p.Results.backgroundColor;
       particleSize = p.Results.particleSize;
       viewCenter = p.Results.viewCenter;
       viewSize = p.Results.viewSize;
       pxHeight = p.Results.pixelHeight;
       pxWidth = pxHeight/viewSize(2)*viewSize(1);
       pxParticleSize = particleSize/viewSize(2)*pxHeight;  
       
       
       diskIm = fspecial('disk', pxParticleSize); % Center is at diskSize+1, diskSize+1  
       diskIm = diskIm./max(diskIm(:));
       diskBlur = particleSize/2;
       
       
       llim = viewCenter - viewSize/2;
       ulim = viewCenter + viewSize/2;
       
       
       [x, y] = meshgrid(linspace(llim(1), ulim(1), pxWidth), linspace(llim(2), ulim(2), pxHeight));
       
       
       
       blurKernel = exp(-((x-viewCenter(1)).^2+(y-viewCenter(2)).^2)./(2*diskBlur.^2));
       normFactor = sum(blurKernel(:));
       
       
       
       
       
       out = zeros(pxHeight, pxWidth);
       
       for k = 1:size(particleList,2)           
           currentCenter = particleList(:,k);
           blurKernel = exp(-((x-currentCenter(1)).^2+(y-currentCenter(2)).^2)./(2*diskBlur.^2));
           blurKernel = blurKernel./(normFactor);
           temp = conv2(blurKernel, diskIm, 'same');
           out = out + temp;

           
       end
       
       
end

