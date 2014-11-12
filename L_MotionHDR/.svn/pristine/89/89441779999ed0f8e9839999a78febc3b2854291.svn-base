function out = getFrameWithoutFocus( ff )
    set(ff, 'Units', 'pixels', 'PaperPositionMode', 'auto');
    set(ff, 'InvertHardCopy', 'off');
     symbols = ['a':'z' 'A':'Z' '0':'9'];
     MAX_ST_LENGTH = 50;
     stLength = randi(MAX_ST_LENGTH);
     nums = randi(numel(symbols),[1 stLength]);
     st = symbols (nums);
     
     outFile = fullfile(tempdir, [st '.png']);
     print(ff, outFile, '-dpng');
     pause(0.01);
     out = imread(outFile);

end

