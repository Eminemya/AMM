function [x0, y0, x1, y1] = getRoi(vidFile)


vid = VideoReader(vidFile);

frame1 = vid.read(1);
[height, width, ~] = size(frame1);


fig = figure;
imshow(frame1);
h = imrect(gca, [10 10 100 100]);
fcn = makeConstrainToRectFcn('imrect', get(gca,'XLim'), get(gca,'YLim'));
setPositionConstraintFcn(h,fcn); 

pos = wait(h);

x0 = min(max(fix(pos(1)), 1), width);
y0 = min(max(fix(pos(2)), 1), height);
x1 = min(max(fix(pos(3)-pos(1)+1), 1), width);
y1 = min(max(fix(pos(4)-pos(2)+1), 1), height);

close(fig);
