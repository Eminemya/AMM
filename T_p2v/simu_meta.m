fprintf('1. get data\n');
fns = 'data/simu/meta.jpg';
im = im2single(imread(fns));
im = im(150:350,500:700);
sz = size(im);

%%
fprintf('2. 1D : phase vs I\n');
fprintf('2.1 global motion\n');
yy=1:sz(2);
v = 1*0.3;
n = 1*v;
im_1d = im(100,:);
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
fprintf('2.1 global motion\n');
psz=5;
[u_p,u_p2]=T_p2v_1d(im_1d,im2_1d,psz);
u_i=T_lk(im_1d,im2_1d,1);
u_i2=T_lk(im_1d,im2_1d,inf);

u_i=T_lk_p3(im,im2,psz,inf);
[u_p1,up2]=T_p2v_1d(im_1d,im2_1d);

%%
fprintf('2. nosie free version: phase vs I');
[yy,xx]=meshgrid(1:sz(2),1:sz(1));
v = [0 1]*1;
im2 = interp2(im,yy+v(2),xx+v(1));
im2(isnan(im2))=0;
psz=5;

u_i=T_lk_p3(im,im2,psz,inf);
u_p=T_p2v(im,im2,psz,4,2);



%%
fprintf('3. noisy version: phase vs I');

n_sc = 0.1;

num_iter = 100;
u = zeros([sz 2 num_iter]);
psz=5;
for iter=1:num_iter
    % assume bilinear model
    im2 = interp2(im,yy+v(2),xx+v(1))+n_sc*randn(sz);
    im2(isnan(im2))=0;
    u(:,:,:,iter)=T_lk_p3(im,im2,psz,inf);
end
err= u;