function [u,u_l2]=T_p2v_1d(signal1,signal2,type)
if ~exist('type','var')
    type =1;
end
signal2=hilbert(signal2);
signal1=hilbert(signal1);
phit = mod(pi+angle(signal2)-angle(signal1),2*pi)-pi;
phix = gradient(unwrap(angle(signal1)));

%{
subplot(222),cla,hold on,
plot(unwrap(angle(signal1)),'b-')
plot(unwrap(angle(signal2)),'r-')
%}
switch type
    case 1
        % global motion
        phit = [reshape(phit,1,[]) 0];
        phix = [reshape(phix,1,[]) 0];
        %subplot(222),cla,hold on,plot(phix,phit,'b.')
        u_l2 = fliplr(polyfit(phit,phix,1));
        u = robustfit(phix,phit);        
    case 2
        % dense motion
end
