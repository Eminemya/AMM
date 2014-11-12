function im = imwarp(im,varargin)

if isa(im,'uint8')
    im = im2double(im);
end

[height,width,nChannels] = size(im);
[xi,yi] = meshgrid(1:width, 1:height);

if length(varargin) == 1 % transformation is given
    T = varargin{1};
    T = inv(T); % apply inverse transform to avoid discontinuities
    sxy = homoTrans(T, [xi(:)' ; yi(:)' ; ones(1,numel(xi))]);
    xi = reshape(sxy(1,:),size(xi,1),size(xi,2));
    yi = reshape(sxy(2,:),size(yi,1),size(yi,2));    
elseif length(varargin) == 2 % displacement field is given
    vx = varargin{1};
    vy = varargin{2};
    xi = xi+vx;
    yi = yi+vy;
else
    error('TODO');
end

for c=1:nChannels
    % warp. label missing values as NaN
    im(:,:,c) = interp2(im(:,:,c), xi, yi, 'bilinear');
end
