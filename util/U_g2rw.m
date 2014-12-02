function out = U_g2rw(im,tmpmax,tmpmin)
if ~exist('tmpmax','var');tmpmax=max(max(im,1),2);end
if ~exist('tmpmin','var');tmpmin=min(min(im,1),2);end
cc = colormap('jet');
sz = size(im);
if numel(sz)==2;sz=[sz 1];end
out = zeros([sz(1:2) 3 sz(3)]);

% standardize intensity
im=im2single(im);
%im=bsxfun(@rdivide,bsxfun(@minus,im,mean(im,3)),std(im,3));
% linear remapping
im=bsxfun(@rdivide,bsxfun(@minus,im,tmpmin),tmpmax);

for i=1:sz(3)
out(:,:,:,i) = ind2rgb(gray2ind(im(:,:,i)),cc);
end
