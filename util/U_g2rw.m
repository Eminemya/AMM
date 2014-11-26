function im = U_g2rw(im)
cc = colormap('jet');
im = ind2rgb(gray2ind(im),cc);
