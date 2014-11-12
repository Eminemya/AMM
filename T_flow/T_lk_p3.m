function [du,V]=T_lk_p3(f1,f2,psz_h,thres,It)
if ~exist('thres','var')
    thres = 1;
end
% 2D: dense motion vectors
% patch lk
[Ix,Iy] = gradient(f1);
sum_p = ones(2*psz_h+1);
Ix = padarray(Ix,[psz_h psz_h],'replicate');
Iy = padarray(Iy,[psz_h psz_h],'replicate');
if ~exist('It','var')
    It = padarray(f2-f1,[psz_h psz_h],'replicate');
else
    It = padarray(It,[psz_h psz_h],'replicate');
end

sz =size(f1);
du = zeros([sz 2]);

Vxx = conv2(Ix.^2,sum_p,'valid');
Vxy = conv2(Ix.*Iy,sum_p,'valid');
Vyy = conv2(Iy.^2,sum_p,'valid');
Ext = conv2(Ix.*It,sum_p,'valid');
Eyt = conv2(Iy.*It,sum_p,'valid');

det = 1./(Vxx.*Vyy-Vxy.^2);
%{
V= [reshape(Vxx,1,1,[]) reshape(Vxy,1,1,[]); ...
    reshape(Vxy,1,1,[]) reshape(Vyy,1,1,[])];
%}
V= [reshape(det.*Vyy,1,[]);reshape(det.*Vxx,1,[])];
du(:,:,1) = -reshape((Vyy.*Ext-Vxy.*Eyt).*det,sz);
du(:,:,2) = -reshape((-Vxy.*Ext+Vxx.*Eyt).*det,sz);

du(abs(du)>thres) = thres*sign(du(abs(du)>thres));
du(isnan(du)) = 0;

%{
im1=magic(1000);im2=im1(:,[2:1000 1]);
tic
a=T_lk_p2(im1,im2,2);
toc
tic
aa=T_lk_p3(im1,im2,2);
toc
%}

