function V_feat(mat,sz,ind,cc)

if iscell(mat)
    num = numel(mat);
else
    mat=squeeze(mat);
    if ~exist('sz','var') || isempty(sz)
        sz =size(mat);
    else
        mat= reshape(mat,sz);
    end

    if exist('ind','var') && ~isempty(ind)
        if numel(sz)==3;mat= mat(:,:,ind);else;mat=mat(:,:,:,ind);end
            sz(end) = numel(ind);
    end
    num= sz(end);
end

col = ceil(sqrt(num));
row = ceil(num/col);

if iscell(mat)
    for i=1:num;
        subplot(row,col,i),
        if exist('cc','var') && ~isempty(cc);
            if numel(cc)==1
            imagesc(mat{i});colorbar;
            else
                imagesc(uint8(mat{i}),cc);
            end 
        else
            imagesc(uint8(mat{i}));
        end
        axis off;
    end
elseif numel(sz)==3
    for i=1:num;
        subplot(row,col,i)
        if exist('cc','var') && ~isempty(cc);
            if numel(cc)==1
                imagesc(mat(:,:,i));colorbar;
            else
                imagesc(mat(:,:,i),cc);
            end
        else
            imagesc(mat(:,:,i));
        end
        axis off;
    end
elseif numel(sz)==4
    for i=1:num;
        subplot(row,col,i)
        if exist('cc','var') && ~isempty(cc);
            if numel(cc)==1
                imagesc(mat(:,:,:,i));colorbar;
            else
                imagesc(mat(:,:,:,i),cc);
            end
        else
            imagesc(uint8(mat(:,:,:,i)));
        end
        axis off;
    end
else
    imagesc(mat);axis off;
    if exist('cc','var') && ~isempty(cc);colorbar;end
end
