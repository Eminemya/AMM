function outVid = vidresize( vid, varargin )
    outVid = imresize(vid(:,:,:,1) ,varargin{:});
    outVid = repmat(outVid, [1 1 1 size(vid,4)]);
    for j = 1:size(vid,4)
       outVid(:,:,:,j) = imresize(vid(:,:,:,j), varargin{:}); 
    end

end

