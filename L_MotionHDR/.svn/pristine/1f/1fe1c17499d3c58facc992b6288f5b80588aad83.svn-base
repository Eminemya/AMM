function outNamess = vidgridDir(index, outNamess, directoryNames, captions, grid, scale)
    for j = 1:numel(directoryNames)
       load(fullfile(directoryNames{j}, 'names.mat'));
       vidName{j} = outName{index};
    end
    vidgridMJPEG(vidName, captions, [outNamess '.avi'], grid, scale);
    system(sprintf('convert2mp4 %s 2000k', [outNamess '.avi']));
    delete([outNamess '.avi']);
end