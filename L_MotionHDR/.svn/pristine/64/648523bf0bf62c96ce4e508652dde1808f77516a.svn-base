function out = fftResize( in, outh, outw )
    [inh, inw] = size(in);
    spectrum = fftshift(fft2(in));
    padLeft = floor((outw-inw-1)/2);
    padRight = outw-inw-padLeft;
    padTop = floor((outh-inh-1)/2);
    padBottom = outh-inh-padTop;
    spectrum = cat(2,zeros(inh, padLeft), spectrum, zeros(inh,padRight));
    spectrum = cat(1,zeros(padTop, outw), spectrum ,zeros(padBottom, outw));
    out = ifft2(ifftshift(spectrum))*outh*outw/inh/inw;
    
    
    

end

