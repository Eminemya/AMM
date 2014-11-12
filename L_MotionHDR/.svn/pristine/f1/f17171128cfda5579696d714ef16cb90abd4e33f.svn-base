function im = imset(im,m,pos)
% Sets image im to m centered at position pos

[height,width,nChannels] = size(m);
pos = round(pos); % use closest integral location

assert(nChannels==size(im,3));

x0 = round(pos(1)-width/2);
x1 = x0+width-1;
y0 = round(pos(2)-height/2);
y1 = y0+height-1;

[X,Y] = meshgrid(x0:x1,y0:y1);
inBounds = X>=1 & X<=size(im,2) & Y>=1 & Y<=size(im,1);
idxIm = sub2ind(size(im(:,:,1)),Y(inBounds),X(inBounds));
% TODO: there's probably a better way for doing this
for c=1:nChannels
    im_c = im(:,:,c);
    m_c = m(:,:,c);
    idxM = find(inBounds);
    im_c(idxIm) = m_c(idxM);
    im(:,:,c) = im_c;
end
