function v_flo= V_flo(tmp_f,max_flo,max_arr,ballSpacing,ran)
sz = size(tmp_f);
tmp_fE = squeeze(sqrt(sum(tmp_f.^2,3)));

v_flo = zeros([sz(1:2),3,size(tmp_f,4)],'uint8');
if ~exist('ballSpacing','var');ballSpacing = 50;end
if ~exist('ran','var');ran={1:sz(1),1:sz(2)};end
if ~exist('max_flo','var');max_flo=max(abs(tmp_fE(:)));end
if ~exist('max_arr','var');max_arr=min(sz(1:2))/10;end

set(0,'DefaultFigureWindowStyle','normal')
for i= 1:size(tmp_f,4)
    clf
    %axis([0 sz(2) 0 sz(1)])
    axis([0 sz(2) 0 sz(1)])
    %imagesc(sqrt(sum(flo(:,:,1:2,i).^2,3))/max_flo),caxis([0 max_flo])
    tmp_im = ind2rgb(gray2ind(uint8(255*tmp_fE(:,:,i)/max_flo),255),jet(255));
    imshow(tmp_im(ran{1},ran{2},:))
    hold on,%axis off,axis tight,axis equal
    curr_f=max_arr*tmp_f(end:-1:1,:,1:2,i)/max_flo;
    h = V_quiver(curr_f,ballSpacing);
    a=getframe;
    v_flo(:,:,:,i) = imresize(a.cdata,sz(1:2),'nearest');
end