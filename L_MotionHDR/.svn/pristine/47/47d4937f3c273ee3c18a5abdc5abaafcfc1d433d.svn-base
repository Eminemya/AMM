function im2 = imscale(im,s)
% Antialiased image and plot scaling

if s==1
    im2 = im;
    return;
end

f = figure(); %('Color',[1,1,1]); % white background
imshow(im);
pos = get(f,'Position');
pos(1:2) = [10,10]; % move near origin
% pos(3:4) = pos(3:4)*s*2;
pos(3:4) = pos(3:4)*s;
set(f,'Position',pos);
    
T = getframe();
im2 = T.cdata(1:end-1,1:end-1,:); % for some reason the capture is one pixel larger...
% im2 = imresize(im2,.5,'bilinear');
close(f);
