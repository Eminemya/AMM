function vid = U_highpass2(vid,win,sigma)
sz= size(vid);
H = fspecial('Gaussian',[1,2*win+1],sigma);
H = H/sum(H(:));
if numel(sz)==3
    pre_mean = mean(vid,3);
    low_win = [0 0 win];
    H = reshape(H,[1,1,numel(H)]);
else
    pre_mean = mean(vid,4);
    low_win = [0 0 0 win];
    H = reshape(H,[1,1,1,numel(H)]);
end


low = convn(padarray(vid,low_win,'replicate'),H,'valid');
vid= vid - low;

if numel(sz)==3
    vid = bsxfun(@plus,bsxfun(@minus,vid,mean(vid,3)),pre_mean);
else
    vid = bsxfun(@plus,bsxfun(@minus,vid,mean(vid,4)),pre_mean);
end

