% phase plane
%%
fid =1;vid =2;
vvs = 10.^(-[0:2]);
mid = 2;
vv = vvs(mid);
for fid = 1:3
    switch fid
        case 1
            step = 0.1;
            x= (0:step:3);
            x2= x-vv;
            signal1 = exp(1i*x*pi*1.5);
            signal2 = exp(1i*x2*pi*1.5);
        case 2
            x= (0:step:99);
            x2= x-vv;
            ff = [0.5 1]';
            signal1 = sum(exp(1i*bsxfun(@times,x,ff)),1);
            signal2 = sum(exp(1i*bsxfun(@times,x2,ff)),1);
        case 3
            step = 1;
            noise = randn(200,1);
            kx =0:step:50;
            kernel1 = exp(-(kx-25).^2/(2*3.^2)).*cos(2*pi*0.1*kx);
            kernel2 = exp(-(kx-vv-25).^2/(2*3.^2)).*cos(2*pi*0.1*(kx-0.1));
            signal1 = hilbert(conv(noise, kernel1));
            signal2 = hilbert(conv(noise, kernel2));
            x = 1:numel(signal1);
    end
    
    
    ran =1:numel(signal1);
    
    tt=angle(signal1(ran));
    rr=abs(signal1(ran));
    bid = find(abs(gradient(unwrap(tt)))>1);
    % phase plane
    subplot(3,3,fid*3-2),cla,hold on
    plot(rr(bid).*cos(tt(bid)),rr(bid).*sin(tt(bid)),'bx')
    plot(real(signal1(ran)),imag(signal1(ran)),'r.')
    plot(0,0,'ko'),axis tight,axis equal
    % Ix-It
    It = real(signal2)-real(signal1);
    Ix = gradient(real(signal1));% (cos(vv)-1)*real(signal1)
    subplot(3,3,fid*3-1),cla,hold on
    set(gca,'FontSize',fontsz)
    plot(Ix,It,'b.')
    p=robustfit(Ix,It);
    p2=polyfit(Ix,It,1);
    plot(Ix,Ix*p(2)+p(1),'r-')
    xlabel('I_x')
    ylabel('I_t')
    title(sprintf('                 L2: %.2f%%; Robust: %.2f%%',100*abs((p2(1)*step+vv)/vv),100*abs((p(2)*step+vv)/vv)))
    
    
    % phix-phit
    
    phit = mod(pi+angle(signal2)-angle(signal1),2*pi)-pi;
    phix = gradient(unwrap(angle(signal1)));
    phit = [reshape(phit,1,[]) 0];
    phix = [reshape(phix,1,[]) 0];
    
    subplot(3,3,fid*3),cla,hold on
    set(gca,'FontSize',fontsz)
    plot(phix,phit,'b.')
    p2 = polyfit(phit,phix,1);
    p = robustfit(phix,phit);
    plot(phix,phix*p(2)+p(1),'r-')
    xlabel('\phi_x')
    ylabel('\phi_t')
    title(sprintf('                 L2: %.2f%%; Robust: %.2f%%',100*abs((p2(1)*step+vv)/vv),100*abs((p(2)*step+vv)/vv)))
    
    % theoretical:
    syms x
    simplify(cos(x)^2+sin(x)^2+1)
    simplify(atan2(sin(x)+sin(2*x),cos(x)+cos(2*x)))
    %{
        clf
        subplot(211),plot(unwrap(angle(signal1)))
        subplot(212),plot(unwrap(angle(signal2)))
    %}
    
end