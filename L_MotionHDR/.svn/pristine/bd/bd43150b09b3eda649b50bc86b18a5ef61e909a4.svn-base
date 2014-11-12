function patch = impatch(im,x,y,siz)

if numel(siz)==1
    h=siz; w=siz;
else
    h=siz(1); w=siz(2);
end

[height,width,nChannels] = size(im);
x1=round(x-w/2); x2=x1+w-1;
y1=round(y-h/2); y2=y1+h-1;
[X,Y] = meshgrid(x1:x2,y1:y2);
inBounds = X>=1 & X<=width & Y>=1 & Y<=height;
patch = zeros(h,w,nChannels,class(im));
idx_im = sub2ind([height,width],Y(inBounds),X(inBounds));
for c=1:nChannels
    im_c = im(:,:,c);
    idx_patch = find(inBounds);
    patch_c = nan(h,w);
    patch_c(idx_patch) = im_c(idx_im);
    patch(:,:,c) = patch_c;
end
