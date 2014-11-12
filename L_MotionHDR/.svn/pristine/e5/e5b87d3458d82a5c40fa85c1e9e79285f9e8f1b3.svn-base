function res = vidcolorize(vid,cmap)

range = [min(vid(:)),max(vid(:))];

res = zeros(size(vid,1),size(vid,2),3,size(vid,4),class(vid));
for i=1:size(vid,4)
    res(:,:,:,i) = imcolorize(squeeze(vid(:,:,:,i)),cmap,range);
end
