fns = {'data/simu/meta2.jpg'};
fid=1;
im = im2single(imread(fns{fid}));
sz = size(im);
[yy,xx]=meshgrid(1:sz(2),1:sz(1));
v = [1 1];
n_sc = 1;

num_iter = 100;
u = zeros([sz 2 num_iter]);
psz=5;
for iter=1:num_iter
    im2 = interp2(im,yy+v(2),xx+v(1))+n_sc*randn(sz);
    im2(isnan(im2))=0;    
    u(:,:,:,iter)=T_lk_p3(im,im2,psz,inf);    
end
err= u;
err(:,:,1,:) = err(:,:,1,:)-v(1);
err(:,:,2,:) = err(:,:,2,:)-v(2);
[~,V]=T_lk_p3(im,im2,psz);

V_x = sqrt(reshape(squeeze(V(1,:)),sz));
V_y = sqrt(reshape(squeeze(V(2,:)),sz));
err_std_x= std(err(:,:,1,:),[],4);
err_std_y= std(err(:,:,2,:),[],4);
%{
subplot(221),imagesc(V_x,[0 15]),axis equal,axis off,title('horizontal motion uncertainty: estimation')
subplot(222),imagesc(err_std_x,[0 15]),axis equal,axis off,title('horizontal motion uncertainty: simulation')
subplot(223),imagesc(V_y,[0 15]),axis equal,axis off,title('vertical motion uncertainty: estimation')
subplot(224),imagesc(err_std_y,[0 15]),axis equal,axis off,title('vertical motion uncertainty: simulation')
saveas(gca,'p2v_cov.png')
%}

tmp_xx = min(V_x(:)):range(V_x(:))/50:max(V_x(:));
tmp_yy = min(V_y(:)):range(V_y(:))/50:max(V_y(:));
[cc_x,ind_x]=histc(V_x(:),tmp_xx);
[cc_y,ind_y]=histc(V_y(:),tmp_yy);
err_std_x_c=zeros(2,numel(cc_x));
err_std_y_c=zeros(2,numel(cc_y));
for i=1:numel(cc_x);
    err_std_x_c(1,i)=mean(err_std_x(ind_x==i));
    err_std_x_c(2,i)=std(err_std_x(ind_x==i));
    err_std_y_c(1,i)=mean(err_std_y(ind_y==i));
    err_std_y_c(2,i)=std(err_std_y(ind_y==i));
end
clf,
%subplot(211),
hold on
errorbar(tmp_xx,err_std_x_c(1,:),err_std_x_c(2,:))
plot(tmp_xx,n_sc*tmp_xx,'r--')
set(gca,'FontSize',15)
xlabel('estimation')
ylabel('simulation')
axis tight,title('vertical motion uncertainty')
legend('emperical','analytical')

saveas(gca,'bgn_model1.png')

subplot(212),hold on
errorbar(tmp_yy,err_std_y_c(1,:),err_std_y_c(2,:))
plot(tmp_yy,n_sc*tmp_xx,'r--')
xlabel('estimation')
ylabel('simulation')
axis tight,title('horizontal motion uncertainty')
set(gca,'FontSize',15)
saveas(gca,'p2v_cov2.png')