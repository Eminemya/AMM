DIR = 'L_Neal/pyrToolsExt/';
addpath(DIR)
fprintf('1. get data\n');
fns = 'meta.jpg';
im = im2single(imread(fns));
im = im(190:270,540:620);
sz = size(im);
do_disp=0;
if do_disp
    %% 
    clf
    imagesc(im)
end
%%
fprintf('2. 1D : phase vs I\n');
fprintf('2.1 global motion\n');
yy=1:sz(2);
v = 1*0.3;
n = 1*v;
im_1d = im(20,:);
num_iter = 200;
err = zeros(num_iter,4);
for i=1:num_iter
im2_1d = interp1(im_1d,yy+v+n*randn(1,numel(im_1d)));
im2_1d(isnan(im2_1d))=0;
% check signal
% cla,hold on,plot(im_1d,'b-');plot(im2_1d,'r-')
% check global motion
[u_p,u_p2]=T_p2v_1d(im_1d,im2_1d);
u_i=T_lk(im_1d,im2_1d,1);
u_i2=T_lk(im_1d,im2_1d,100);
err(i,:) = [abs(u_p(2)-v),abs(u_p2(2)-v),abs(u_i+v),abs(u_i2+v)];
end
% phase-L1, phase-L2, intensity-L2, intensity-L2-iter
fprintf('Noise: %.2f, err: %.4f,%.4f,%.4f,%.4f\n',n/v,mean(err(:,1)),mean(err(:,2)),mean(err(:,3)),mean(err(:,4)))

%%
fprintf('2. 2D motion: phase vs I');
[yy,xx]=meshgrid(1:sz(2),1:sz(1));
v = [0 1]*0.3;
im2 = interp2(im,yy+v(2),xx+v(1));
im2(isnan(im2))=0;
patch_sz=5;
num_orientation = 4;
band_level = 4;
u_i=T_lk_p3(im,im2,patch_sz,1);
u_i2=T_lk_p3(im,im2,patch_sz,inf);
[u_p,u_p2]=T_p2v(im,im2,patch_sz,num_orientation,band_level);
if do_disp
    %% 
    ran = [-max(abs(v)) max(abs(v))];
    subplot(221),imagesc(reshape(u_i,sz(1),[]),ran)
    subplot(222),imagesc(reshape(u_i2,sz(1),[]),ran)
    subplot(223),imagesc(reshape(u_p,sz(1),[]),ran)
    subplot(224),imagesc(reshape(u_p2,sz(1),[]),ran)
end