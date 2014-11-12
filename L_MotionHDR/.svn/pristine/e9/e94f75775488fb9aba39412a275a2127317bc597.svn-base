clear;
close all;
directories = {'testAutoGainOriginal', 'testAutoGainControl', 'testAutoGain001'};
captions = {'Original', 'Multiplied by Alpha', 'Hilbert Auto Gain'};
names = {'crane', 'guitar', 'baby', 'camera', 'violin', 'column','smoke'};
figDir = mfilename;
mkdir(figDir);
grids{1} = [1 3];
grids{2} = [1 3];
grids{3} = [1 3];
grids{4} = [1 3];
grids{5} = [1 3];
grids{6} = [1 3];
grids{7} = [1 3];

scales = [1 1 0.5 1 1 1 1];

for j = 1:numel(names)
   vidgridDir(j, fullfile(figDir, names{j}), directories, captions, grids{j}, scales(j)); 
end