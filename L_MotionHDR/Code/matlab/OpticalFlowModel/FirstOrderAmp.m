clear;
close all;
sigma = 0.1;
x = linspace(-4,4,100);
y = exp(-x.^2/(2*sigma^2));
plot(y)

y = repmat(y, [100 1]);

[pyr, pind] = buildSCFpyr(y);
level = pyrBand(pyr,pind, 6);
figure();
level = level(25,:);
plot(real(level));
hold on;
plot(imag(level),'r');

% 
factor = 1000;
G = resample(real(level),factor,1);
H = resample(imag(level), factor,1);
Gp = convn(G, [0.5 0 -0.5], 'same');
Hp = convn(H, [0.5 0 -0.5], 'same');
figure();
plot(G);hold on;
plot(H, 'r')

figure();
plot(G.*Gp+H.*Hp)
%%
%syms x y;
%I0 = exp(-x.^2/2);
%G4_f1 = 1.246*(0.75-3*x.^2+x.^4).*exp(-x.^2);
%H4_f1 = 0.3975.*(7.189*x-7.501.*x.^3+x.^5).*exp(-x.^2);
%G4 = exp(-x.^2/2)*cos(x);
%H4 = exp(-x.^2/2)*sin(x);

%ifourier(fourier(G4_f1,x)*fourier(I0, x)) *ifourier(i*x*fourier(G4_f1,x)*fourier(I0, x)) +...
%ifourier(fourier(H4_f1,x)*fourier(I0, x))*ifourier(i*x*fourier(H4_f1,x)*fourier(I0, x))

