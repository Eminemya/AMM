function im = colorize(m,cmap,range)

if exist('cmap','var')~=1
    cmap = jet(256);
end
if exist('range','var')~=1 || isempty(range)
    range = [min(m(:)),max(m(:))];
end

% normalize to 0..1
m = (m - range(1)) / (range(2)-range(1));
m(isnan(m)) = 0;
im = reshape(interp2(1:3,1:length(cmap),cmap, ...
                     1:3,1+m(:)*(size(cmap,1)-1)), ...
             [size(m),3]);
