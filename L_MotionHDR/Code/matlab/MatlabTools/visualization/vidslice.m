function slice = vidslice(vid,dim,pos)
% Renders a spatiotemporal slice of a video
% TODO: make sure we slice in exactly one dimension
%
% Michael Rubinstein, MIT 2010


if isa(vid,'MyVideoReader')
    seq = vid.load;
else
    seq = vid;
end

if strcmp(dim,'x')==1 % YT
    slice = permute(squeeze(seq(:,pos,:,:)),[1,3,2]); 
    xLabel = 'T'; yLabel = 'Y';
elseif strcmp(dim,'y')==1
    slice = permute(squeeze(seq(pos,:,:,:)),[3,1,2]); 
    slice = slice(end:-1:1,:,:); % flip
    xLabel = 'X'; yLabel = 'T';
end

if nargout == 0
    figure;
    imshow(slice);
    xlabel(xLabel); ylabel(yLabel);
end
