% Function to generate multiscale noise that can be used as backgrounds for
% Schlieren flow. 
%
% Neal Wadhwa, March 2013
function out = GenWaveletNoise( h,w, outFile )

out = zeros(h,w);
ht = ceil(log2(h))-3;
for k = 0:ht-1;
    B = randn(fix(h/2.^k),fix(w/2.^k));
    C = blurDn(B,1);
    addi = imresize(B-imresize(C,size(B)),[h w]);
    out = out + addi;
    
end
minA = min(out(:));
maxA = max(out(:));
out = (out-minA)/(maxA-minA);
if (exist('outFile', 'var'))
    imwrite(out, outFile);
end


end

