function dispImageSet( ims )
    out = cat(2,ims{1}, ims{2});
    for j = 3:numel(ims)
       out = cat(2,out, ims{j}); 
    end
    figure();
    imagesc(out);
    axis equal;
end

