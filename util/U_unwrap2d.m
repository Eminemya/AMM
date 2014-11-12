function out=U_unwrap2d(im,opt)
if ~exist('opt','var')
    opt=0;
end
switch opt
    case 0
        out = unwrap(im);
    case 1
        out = im;
        for i=1:size(im,1)
            out(i,:) = unwrap(im(i,:));
        end
end