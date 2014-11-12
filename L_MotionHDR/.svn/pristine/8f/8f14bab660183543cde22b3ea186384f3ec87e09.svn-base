function denoiseNLMeans(vidFile,outFile)

[mpath,~] = fileparts(mfilename('fullpath'));
tmpDir = fullfile(mpath,'tmp_denoiseNLMeans');
mkdir(tmpDir);

% use ImageStack
% http://code.google.com/p/imagestack/
imageStackBin = fullfile(mpath,'NLMeans','ImageStack.exe');

vid = MyVideoReader(vidFile);
outVid = MyVideoWriter(outFile);

% process sequencially for now
for i=1:vid.length
    fprintf('frame %d/%d\n',i,vid.length);
    
    frame = vid.frame(i);
    imwrite(frame,fullfile(tmpDir,'frame.png'));
    % parameters taken from help message (ImageStack.exe -help nlmeans)
    cmd = [imageStackBin ' -load ' fullfile(tmpDir,'frame.png') ' -nlmeans 1.0 6 50 0.02 -save ' fullfile(tmpDir,'frame_denoised.png')];
    system(cmd);
    
    % read back the result
    frameDenoised = imread(fullfile(tmpDir,'frame_denoised.png'));
    outVid.append(frameDenoised);
end

outVid.close;
