function U_arrowhead2(hq1,headHeight0,tmp_im)
%get the line position (first handle)
hkid = get(hq1,'children');
X = get(hkid(1),'XData');
Y = get(hkid(1),'YData');
clf
if exist('tmp_im','var')
    imshow(tmp_im)
end
%ax = axis;
%ap = get(gca,'Position');
axis off;
%title('Quiver - regular ','FontSize',16);

%right version (with annotation)
%hax_2 = subplot(1,2,2);
%cmap = jet(116); %colormap, 116 because angles goes up to 115 degrees

for ii = 1:3:length(X)-1
    
    headHeight = headHeight0 * sqrt((X(ii+1)-X(ii)).^2 + (Y(ii+1)-Y(ii)).^2); % set the headHeight, function of length of arrow
    
    %angled = floor(atan2(Y(ii+1)-Y(ii),X(ii+1)-X(ii))*180/pi) + 1; %get the angle
    if 0
        xp = (Y(ii:ii+1)-ax(1))/(ax(2)-ax(1))*ap(3)+ap(1);
        yp = (X(ii:ii+1)-ax(3))/(ax(4)-ax(3))*ap(4)+ap(2);
        annotation('arrow',...
            yp,xp,...
            'Color', [0 0 0],...
            'LineStyle','none',...
            'headStyle','plain','HeadLength',3*headHeight,'HeadWidth',1*headHeight);
    else
        ah = annotation('arrow',...
            'Color', [0 0 0],...
            'LineStyle','none',...
            'headStyle','plain','HeadLength',30*headHeight,'HeadWidth',10*headHeight);
        set(ah,'parent',gca);
        % match the arrow-head postion
        %set(ah,'position',[X(ii) Y(ii) X(ii+1)-X(ii) Y(ii+1)-Y(ii)]);
        % match the arrow-base postion
        set(ah,'position',[2*X(ii)-X(ii+1) 2*Y(ii)-Y(ii+1) X(ii+1)-X(ii) Y(ii+1)-Y(ii)]);
    end
    
    %set(ah,'position',[X(ii) Y(ii) 0 0]);
    %set(ah,'X',[X(ii) X(ii)],'Y',[Y(ii) Y(ii)]);
    if mod(ii,ceil(length(X)/30))==0
        disp(sprintf('plot arrow: %d/%d',ii,length(X)))
    end
end
axis off;
%{



clf,imagesc(zeros(10))
ax = axis;
ap = get(gca,'Position')
%% annotation from 1,2 to 3,4
xo = [1,3];
yo = [2,4];
xp = (xo-ax(1))/(ax(2)-ax(1))*ap(3)+ap(1);
yp = (yo-ax(3))/(ax(4)-ax(3))*ap(4)+ap(2);
ah = annotation('arrow',...
        xp,yp,...
        'Color', [0 0 0],...
        'LineStyle','none',...
        'headStyle','plain','HeadLength',30,'HeadWidth',10);


set(ah,'parent',gca);
set(ah,'position',);






clf
headHeight=100;
theta=pi/6;

angle=pi*0;
arr_h = max([headHeight*tan(theta)*sin(angle) headHeight/cos(theta)*cos(theta+[-angle angle])]);
arr_w = max([headHeight*tan(theta)*cos(angle) headHeight/cos(theta)*sin(theta+[-angle angle])]);
    ah = annotation('arrow',...
        'Color', [0 0 0],...
        'LineStyle','none',...
        'headStyle','plain','HeadLength',arr_h);
set(ah,'position',[X(ii) Y(ii) 100*sin(angle) 100*cos(angle)]);


angle=pi;
arr_h = max([headHeight*tan(theta)*sin(angle) headHeight/cos(theta)*cos(theta+[-angle angle])]);
arr_w = max([headHeight*tan(theta)*cos(angle) headHeight/cos(theta)*sin(theta+[-angle angle])]);
    ah = annotation('arrow',...
        'Color', [1 0 0],...
        'LineStyle','none',...
        'headStyle','plain','HeadLength',arr_h,'headWidth',arr_w);
    set(ah,'parent',gca);
axis equal




headHeight=100;
theta=pi/6;

angle=pi*0;
arr_h = max([headHeight*tan(theta)*sin(angle) headHeight/cos(theta)*cos(theta+[-angle angle])]);
arr_w = max([headHeight*tan(theta)*cos(angle) headHeight/cos(theta)*sin(theta+[-angle angle])]);
    ah = annotation('arrow',...
        'Color', [0 0 0],...
        'LineStyle','none',...
        'headStyle','plain','HeadLength',arr_h);
set(ah,'position',[X(ii) Y(ii) 100*sin(angle) 100*cos(angle)]);


angle=pi;
arr_h = max([headHeight*tan(theta)*sin(angle) headHeight/cos(theta)*cos(theta+[-angle angle])]);
arr_w = max([headHeight*tan(theta)*cos(angle) headHeight/cos(theta)*sin(theta+[-angle angle])]);
    ah = annotation('arrow',...
        'Color', [1 0 0],...
        'headStyle','plain','HeadLength',arr_h,'headWidth',arr_w);
    set(ah,'parent',gca);
    

axis equal







%}
%{
%some data
[x,y] = meshgrid(0:0.2:2,0:0.2:2);
u = cos(x).*y;
v = sin(x).*y;

%quiver plots
figure('Position',[10 10 1000 600],'Color','w');
hax_1 = subplot(1,2,1);

%left version (regular)
hq1 = quiver(x,y,u,v);

%get the line position (first handle)
hkid = get(hq1,'children');
X = get(hkid(1),'XData');
Y = get(hkid(1),'YData');
axis off;
title('Quiver - regular ','FontSize',16);

%right version (with annotation)
hax_2 = subplot(1,2,2);
cmap = jet(116); %colormap, 116 because angles goes up to 115 degrees

for ii = 1:3:length(X)-1
    headHeight = 200 * sqrt((X(ii+1)-X(ii)).^2 + (Y(ii+1)-Y(ii)).^2); % set the headHeight, function of length of arrow
    angled = floor(atan2(Y(ii+1)-Y(ii),X(ii+1)-X(ii))*180/pi) + 1; %get the angle
    ah = annotation('arrow',...
        'Color', cmap(angled,:),...
        'headStyle','cback1','HeadLength',50,'headHeight',headHeight);
    set(ah,'parent',gca);
    set(ah,'position',[X(ii) Y(ii) X(ii+1)-X(ii) Y(ii+1)-Y(ii)]);
end
axis off;
title('Quiver - annotations ','FontSize',16);

linkaxes([hax_1 hax_2],'xy');
%}