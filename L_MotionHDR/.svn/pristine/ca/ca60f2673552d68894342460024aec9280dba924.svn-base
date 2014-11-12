clear;
close all;
directories = {'testAutoGainOriginal', 'testAutoGainControl', 'testAutoGain002' ,'testAutoGain001'};
captions = {'Original', 'Multiplied by Alpha', 'Abs. Value Auto Gain', 'Hilbert Auto Gain'};
names = {'crane', 'guitar', 'baby', 'camera', 'violin', 'column','smoke'};
figDir = mfilename;
mkdir(figDir);
grids{1} = [2 2];
grids{2} = [2 2];
grids{3} = [2 2];
grids{4} = [2 2];
grids{5} = [2 2];
grids{6} = [1 4];
grids{7} = [1 4];

scales = [1 1 0.5 1 1 1 1];

for j = 1:numel(names)
   vidgridDir(j, fullfile(figDir, names{j}), directories, captions, grids{j}, scales(j)); 
end