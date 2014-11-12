function [ pyr ] = buildG4H4pyr( im, startLevel, endLevel , thetas)

if (nargin <4)
    thetas = [0 pi/4 pi/2 3*pi/4];
end

spacing = 0.5;
x = -6*spacing:spacing:6*spacing;

G4_f1 = 1.246*(0.75-3*x.^2+x.^4).*exp(-x.^2);
G4_f2 = exp(-x.^2);
G4_f3 = (-1.5*x+x.^3).*exp(-x.^2);
G4_f4 = 1.246.*x.*exp(-x.^2);
G4_f5 = sqrt(1.246).*(x.^2-0.5).*exp(-x.^2);

H4_f1 = 0.3975.*(7.189*x-7.501.*x.^3+x.^5).*exp(-x.^2);
H4_f2 = exp(-x.^2);
H4_f3 = 0.3975.*(1.438-4.501*x.^2+x.^4).*exp(-x.^2);
H4_f4 = x.*exp(-x.^2);
H4_f5 = 0.3975.*(x.^3-2.225*x).*exp(-x.^2);
H4_f6 = (x.^2-0.6638).*exp(-x.^2);


G4a_weights = cos(thetas).^4;
G4b_weights = -4.*cos(thetas).^3.*sin(thetas);
G4c_weights = 6.*cos(thetas).^2.*sin(thetas).^2;
G4d_weights = -4.*cos(thetas).*sin(thetas).^3;
G4e_weights = sin(thetas).^4;

H4a_weights = cos(thetas).^5;
H4b_weights = -5.*cos(thetas).^4.*sin(thetas);
H4c_weights = 10.*cos(thetas).^3.*sin(thetas).^2;
H4d_weights = -10.*cos(thetas).^2.*sin(thetas).^3;
H4e_weights = 5.*cos(thetas).*sin(thetas).^4;
H4f_weights = -sin(thetas).^5;

pyr = [];
pind = zeros(0,2);
convType = 'valid';

im = blurDn(im, startLevel -1);
count = 1;
for k = 1:endLevel-startLevel+1
   G4a = convn(convn(im, G4_f1, convType), G4_f2', convType);
   G4b = convn(convn(im, G4_f3, convType), G4_f4', convType);
   G4c = convn(convn(im, G4_f5, convType), G4_f5', convType);
   G4d = convn(convn(im, G4_f4, convType), G4_f3', convType);
   G4e = convn(convn(im, G4_f2, convType), G4_f1', convType);
   
   H4a = convn(convn(im, H4_f1, convType), H4_f2', convType);
   H4b = convn(convn(im, H4_f3, convType), H4_f4', convType);
   H4c = convn(convn(im, H4_f5, convType), H4_f6', convType);
   H4d = convn(convn(im, H4_f6, convType), H4_f5', convType);
   H4e = convn(convn(im, H4_f4, convType), H4_f3', convType);
   H4f = convn(convn(im, H4_f2, convType), H4_f1', convType);
   for l = 1:numel(thetas)
       
      realPart =  G4a_weights(l).*G4a +  G4b_weights(l).*G4b +   G4c_weights(l).*G4c + G4d_weights(l).*G4d + G4e_weights(l).*G4e;
      imagPart = H4a_weights(l).*H4a + H4b_weights(l).*H4b + H4c_weights(l).*H4c + H4d_weights(l).*H4d + H4e_weights(l).*H4e + H4f_weights(l).*H4f;      
      temp = realPart+1i*imagPart;
      pyr{count} = temp;
      count =count + 1;
      %pyr = [pyr; temp(:)];
      %pind = [pind; size(temp)];
   end
   
   im = blurDn(im,1);
   
end




end

