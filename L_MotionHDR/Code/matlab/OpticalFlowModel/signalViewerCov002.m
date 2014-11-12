function signalViewerCov002( frame, precisionMatrix )
    N = 100;
    orientations = 4;
    scales = 5;
    thetas = [0 pi/4 pi/2 3*pi/4];
    [buildPyr, ~] = octave4PyrFunctions(23,23);
    
    impulse = zeros(23,23);
    impulse(12,12) = 1;
    [impulseResponse, pind1] = buildPyr(impulse);
    [buildPyr, ~] = octave4PyrFunctions(size(frame,1), size(frame,2));
    [pyr, pind2] = buildPyr(mean(im2single(frame),3));
    %% Show levels
    fig0 = figure();
    count = 1;
    for k = 1:4
       subplot(scales+1,orientations, count);
       imagesc(real(pyrBand(impulseResponse, pind1, k+1)));
       axis equal;
      set(gca,'xtick', []);
      set(gca,'ytick', []);
       count = count + 1;
    end
    
    for i = 1:20
            subplot(scales+1, orientations, count);            
            count = count + 1;
            imagesc(abs(pyrBand(pyr, pind2, i+1)));    
            axis equal;
            set(gca,'xtick', []);
            set(gca,'ytick', []);
    end
    colormap('gray');
    
    %% Rest of stuff
    [x, y] = meshgrid(linspace(-3,3,N), linspace(-3,3,N));
    fig1 = figure();
    imshow(frame);
    fig2 = figure();
    while (true)
        figure(fig1);
        [XX,YY] = (ginput(1));
        XX = round(XX)
        YY = round(YY)
        figure(fig2);
        V = precisionMatrix(:,:,YY,XX);
        
        pdf=  exp(-(V(1,1)*x.^2+V(2,2).*y.^2+2*V(1,2)*x.*y));
        pdf = pdf./sum(pdf(:));
        imagesc(linspace(-3,3,N), linspace(-3,3,N),pdf); 
        xlabel('Velocity (x)');
        ylabel('Velocity (y)');
        title('Covariance of Velocity');
        
        colorbar;
        
    end

    
    
    
    
    
    


end

