function fig = vidcube(vid)
% vid can be either MyVideoReader class, or the video block

if isa(vid,'MyVideoReader')
    seq = vid.load;
else
    seq = vid;
end
[height,width,nChannels,len] = size(seq);

vr = squeeze(seq(:,:,1,:));
vg = squeeze(seq(:,:,2,:));
vb = squeeze(seq(:,:,3,:));

fig=figure; 
hold on;

%--------------------------------------------------------------------------

% for i=[1:len/2:len];
for i=[1,len]
front_face = zeros(height,width,3);
front_face(:,:,1) = flipud(vr(:,:,i));
front_face(:,:,2) = flipud(vg(:,:,i));
front_face(:,:,3) = flipud(vb(:,:,i));
 
[xx,zz]=meshgrid(1:width,1:height); 
yy=ones(size(xx))*i; 
surf(xx,yy,zz,front_face/max(front_face(:)),'EdgeColor','none');
% alpha(0.8);
end

%--------------------------------------------------------------------------

up_face = zeros(len,width,3);
up_face(:,:,1) = squeeze(vr(1,:,:))';
up_face(:,:,2) = squeeze(vg(1,:,:))';
up_face(:,:,3) = squeeze(vb(1,:,:))';

[xx,yy]=meshgrid(1:width,1:len); 
zz=ones(size(xx)).*height; 
surf(xx,yy,zz,up_face/max(up_face(:)),'EdgeColor','none');
% alpha(.8);

%--------------------------------------------------------------------------

down_face = zeros(len,width,3);
down_face(:,:,1) = squeeze(vr(end,:,:))';
down_face(:,:,2) = squeeze(vg(end,:,:))';
down_face(:,:,3) = squeeze(vb(end,:,:))';

[xx,yy]=meshgrid(1:width,1:len); 
zz=ones(size(xx));
C=double(down_face);
surf(xx,yy,zz,C/255.0,'EdgeColor','none');

%--------------------------------------------------------------------------

right_face = zeros(height,len,3);
right_face(:,:,1) = flipud(squeeze(vr(:,end,:)));
right_face(:,:,2) = flipud(squeeze(vg(:,end,:)));
right_face(:,:,3) = flipud(squeeze(vb(:,end,:)));

[yy,zz]=meshgrid(1:len,1:height); 
xx=ones(size(yy)).*width; 
surf(xx,yy,zz,right_face/max(right_face(:)),'EdgeColor','none');

%--------------------------------------------------------------------------

left_face = zeros(height,len,3);
left_face(:,:,1) = flipud(squeeze(vr(:,1,:)));
left_face(:,:,2) = flipud(squeeze(vg(:,1,:)));
left_face(:,:,3) = flipud(squeeze(vb(:,1,:)));

[yy,zz]=meshgrid(1:len,1:height); 
xx=ones(size(yy));
C=double(left_face);
surf(xx,yy,zz,C/255.0,'EdgeColor','none');

%--------------------------------------------------------------------------

back_face = zeros(height,width,3);
back_face(:,:,1) = flipud(vr(:,:,end));
back_face(:,:,2) = flipud(vg(:,:,end));
back_face(:,:,3) = flipud(vb(:,:,end));

[xx,zz]=meshgrid(1:width,1:height); 
yy=ones(size(xx))*len; 
C=double(back_face);
surf(xx,yy,zz,C/255.0,'EdgeColor','none');


%--------------------------------------------------------------------------

% Cosmetics
xlim([1,width]);
ylim([1,len]);
zlim([1,height]);

set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'ztick',[]);

box on;
% axis equal;

set(gcf,'Color',[1,1,1]);
set(gca,'Color',[1,1,1]);
set(gca,'LineWidth',2);
set(gcf,'Position',[50,50,820,580]);

% view(38,26);
view(26,22);
box('on');
hold('all');

% light('Position',[0.0684 -0.7231 0.6874]);

% light('Position',[-0.6378 -0.4533 0.6226]);

