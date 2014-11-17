function [du,V]=T_lk_p4(f1,f2,min_sz,psz_h,thres)
% multi-scale: naive approach

% pyramid of 2
sz= size(f1);
factor = 2;
num_sc = 1+floor(log(max(sz(1:2))/min_sz)/log(factor));
u = zeros([sz(1:2) 2]);
if ~exist('thres','var')
    thres = psz_h*2+1;
end


for i=1:num_sc
    f1_l = imresize(f1,factor.^(i-num_sc),'bilinear');
    f2_l = imresize(f2,factor.^(i-num_sc),'bilinear');
    sz_l = size(f1_l);
    if i==1
        du = zeros([sz_l(1:2) 2]);
    else
        pre_sz = size(du);
        du = imresize(du,sz_l,'bilinear');
        du(:,:,1) = du(:,:,1)*sz_l(1)/pre_sz(1);
        du(:,:,2) = du(:,:,2)*sz_l(2)/pre_sz(2);
    end
    
    
    % 2D: dense motion vectors
    % patch lk
    [Ix,Iy] = gradient(f1_l);
    sum_p = ones(2*psz_h+1);
    Ix = padarray(Ix,[psz_h psz_h],'replicate');
    Iy = padarray(Iy,[psz_h psz_h],'replicate');
    
    It = padarray(f2_l-f1_l,[psz_h psz_h],'replicate');
    
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
    du(:,:,1) = -reshape((Vyy.*Ext-Vxy.*Eyt).*det,sz_l);
    du(:,:,2) = -reshape((-Vxy.*Ext+Vxx.*Eyt).*det,sz_l);
    
    du(abs(du)>thres) = thres*sign(du(abs(du)>thres));
    du(isnan(du)) = 0;
    du = U_medfilt2(du,[5 5]);
end

%{
im1=magic(1000);im2=im1(:,[2:1000 1]);
tic
a=T_lk_p2(im1,im2,2);
toc
tic
aa=T_lk_p3(im1,im2,2);
toc
%}

