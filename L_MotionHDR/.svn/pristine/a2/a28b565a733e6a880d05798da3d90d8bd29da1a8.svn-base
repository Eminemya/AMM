function fig = vidcubeBWNoScale(vid)
% vid can be either MyVideoReader class, or the video block

if isa(vid,'MyVideoReader')
    seq = vid.load;
else
    seq = vid;
end
[height,width,nChannels,len] = size(seq);

vr = squeeze(seq(:,:,1,:));

fig=figure; 
hold on;

%--------------------------------------------------------------------------

% for i=[1:len/2:len];
for i=[1,len]
front_face = zeros(height,width);
front_face(:,:,1) = flipud(vr(:,:,i));

 
[xx,zz]=meshgrid(1:width,1:height); 
yy=ones(size(xx))*i; 
surf(xx,yy,zz,front_face,'EdgeColor','none'); colormap('gray'); caxis([0 1]);
% alpha(0.8);
end

%--------------------------------------------------------------------------

up_face = zeros(len,width);
up_face(:,:,1) = squeeze(vr(1,:,:))';


[xx,yy]=meshgrid(1:width,1:len); 
zz=ones(size(xx)).*height; 
surf(xx,yy,zz,up_face,'EdgeColor','none');
% alpha(.8);

%--------------------------------------------------------------------------

down_face = zeros(len,width);
down_face(:,:,1) = squeeze(vr(end,:,:))';


[xx,yy]=meshgrid(1:width,1:len); 
zz=ones(size(xx));
C=double(down_face);
surf(xx,yy,zz,C/255.0,'EdgeColor','none');

%--------------------------------------------------------------------------

right_face = zeros(height,len);
right_face(:,:,1) = flipud(squeeze(vr(:,end,:)));
[yy,zz]=meshgrid(1:len,1:height); 
xx=ones(size(yy)).*width; 
surf(xx,yy,zz,right_face,'EdgeColor','none');

%--------------------------------------------------------------------------

left_face = zeros(height,len);
left_face(:,:,1) = flipud(squeeze(vr(:,1,:)));

[yy,zz]=meshgrid(1:len,1:height); 
xx=ones(size(yy));
C=double(left_face);
surf(xx,yy,zz,C/255.0,'EdgeColor','none');

%--------------------------------------------------------------------------

back_face = zeros(height,width);
back_face(:,:,1) = flipud(vr(:,:,end));

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

