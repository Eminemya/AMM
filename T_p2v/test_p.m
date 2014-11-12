%%
fid =2;vid =2;
vvs = 10.^(-[0:2]);
mid = 2;
vv = vvs(mid);

switch fid
    case 0
        step = 0.1;
        x= (0:step:3);
        x2= x-vv;
        signal1 = exp(1i*x*pi*1.5);
        signal2 = exp(1i*x2*pi*1.5);
    case 1
        x= (0:step:99);
        x2= x-vv;
        ff = [0.5 1]';
        signal1 = sum(exp(1i*bsxfun(@times,x,ff)),1);
        signal2 = sum(exp(1i*bsxfun(@times,x2,ff)),1);
    case 2
        step = 1;
        noise = randn(200,1);
        kx =0:step:50;
        kernel1 = exp(-(kx-25).^2/(2*3.^2)).*cos(2*pi*0.1*kx);
        kernel2 = exp(-(kx-vv-25).^2/(2*3.^2)).*cos(2*pi*0.1*(kx-0.1));        
        signal1 = hilbert(conv(noise, kernel1));
        signal2 = hilbert(conv(noise, kernel2));
        x = 1:numel(signal1);
end

clf;
switch vid
    case 1
        subplot(221),hold on
        plot(real(signal1),'b-')
        plot(real(signal2),'r-')
        
        subplot(222),hold on
        plot(imag(signal1),'b-')
        plot(imag(signal2),'r-')
        
        subplot(223),hold on
        plot(unwrap(angle(signal1)),'b-')
        plot(unwrap(angle(signal2)),'r-')
        subplot(224),hold on
        plot(abs(signal1),'b-')
        plot(abs(signal2),'r-')
        subplot(224)
        %plot((mod(pi+angle(signal2)-angle(signal),2*pi)-pi)./gradient(unwrap(angle(signal))))
    case 2
        fontsz = 15;
        subplot(221),cla
        set(gca,'FontSize',fontsz)
        plot(x,real(signal1),'b-'); hold on;
        plot(x,real(signal2),'r-')
        xlabel('x')
        title('signal')
        %{
        plot(abs(signal1),'b-'); hold on;
        plot(abs(signal2),'r-')
        ylabel('amplitude')
        xlabel('x')
        title('signal amplitude')
        axis tight
        %}
        
        subplot(222),cla
        set(gca,'FontSize',fontsz)
        plot(x,unwrap(angle(signal1)),'b-'); hold on;
        plot(x,unwrap(angle(signal2)),'r-')
        title('signal phase')
        ylabel('phase')
        xlabel('x')
        axis tight
        
        phit = mod(pi+angle(signal2)-angle(signal1),2*pi)-pi;
        phix = gradient(unwrap(angle(signal1)));
        phit = [reshape(phit,1,[]) 0];
        phix = [reshape(phix,1,[]) 0];
        
        subplot(223),cla,hold on        
        set(gca,'FontSize',fontsz)
        plot(phix,phit,'b.')
        p2 = polyfit(phit,phix,1);
        p = robustfit(phix,phit);
        plot(phix,phix*p(2)+p(1),'r-')
        xlabel('\phi_x')
        ylabel('\phi_t')
        title(sprintf('                 L2: %.2f%%; Robust: %.2f%%',100*abs((p2(1)*step+vv)/vv),100*abs((p(2)*step+vv)/vv)))
        %{
        clf
        subplot(211),plot(unwrap(angle(signal1)))
        subplot(212),plot(unwrap(angle(signal2)))
        %}
        It = real(signal2)-real(signal1);
        Ix = gradient(real(signal1));
        subplot(224),cla,hold on
        set(gca,'FontSize',fontsz)
        plot(Ix,It,'b.')
        p=robustfit(Ix,It);
        p2=polyfit(Ix,It,1);
        plot(Ix,Ix*p(2)+p(1),'r-')
        xlabel('I_x')
        ylabel('I_t')
        title(sprintf('                 L2: %.2f%%; Robust: %.2f%%',100*abs((p2(1)*step+vv)/vv),100*abs((p(2)*step+vv)/vv)))
end
saveas(gca,sprintf('p2v_%d_%d.png',fid,mid))