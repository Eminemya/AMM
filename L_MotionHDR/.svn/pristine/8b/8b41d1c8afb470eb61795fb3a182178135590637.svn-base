function vidwrite(vid, fileName)

vidWriter = MyVideoWriter(fileName);
for i=1:size(vid,4)
    vidWriter.append(uint8(vid(:,:,:,i)));
end
vidWriter.close;
