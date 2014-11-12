function [ output_args ] = signalViewerCov( frame, precisionMatrix )
    N = 100;
    
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

