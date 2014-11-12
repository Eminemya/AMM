function out = U_crop(im)
rowsum = sum(im(:,:,1)~=0,2);
rowind = find(rowsum);
colsum = sum(im(:,:,1)~=0);
colind = find(colsum);

out = im(rowind(1):rowind(end),colind(1):colind(end),:);