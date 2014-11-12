clear im;
im{1} =  im2single(imread('cameraman.tif'));
im{2} = im{1}(1:255,:);
im{3} = im{1}(:, 1:255);
im{4} = im{1}(1:255, 1:255);

outSizes = [512 512; 511 512; 512 511; 511 511];
figure();
count = 1;
for k = 1:numel(im)
    for j = 1:size(outSizes,1)
        outIm{k,j} = fftResize(im{k}, outSizes(j,1), outSizes(j,2));
        subplot(4,4,count);
        count = count + 1;
        imshow(outIm{k,j});
    end
end

    
    