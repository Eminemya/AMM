function U_implay(ims)
sz =size(ims);
if numel(sz)==3
    for i=1:sz(end)
        imagesc(ims(:,:,i))
    	title(i)
        waitforbuttonpress
    end
else
    for i=1:sz(end)
        imagesc(uint8(ims(:,:,:,i)))
    	title(i)
        waitforbuttonpress
    end
end
