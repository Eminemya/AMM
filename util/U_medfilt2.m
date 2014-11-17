function y= U_medfilt2(im,psz)
y= im;
if numel(psz)==1
    psz =[psz psz];
end
for i=1:size(y,3)
for j=1:size(y,4)
    y(:,:,i,j) = medfilt2(im(:,:,i,j),psz); 
end
end
