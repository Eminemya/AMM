function install()

mpath = mfilename('fullpath');
HOME = fileparts(mpath);

addpath(fullfile(HOME));
addpath(fullfile(HOME,'color'));
addpath(fullfile(HOME,'image'));
addpath(fullfile(HOME,'io'));
addpath(fullfile(HOME,'math'));
addpath(fullfile(HOME,'thirdparty'));
addpath(fullfile(HOME,'thirdparty','BroxLDOF'));
addpath(fullfile(HOME,'thirdparty','ColorImage'));
addpath(fullfile(HOME,'thirdparty','export_fig'));
addpath(fullfile(HOME,'thirdparty','matlabPyrTools'));
addpath(fullfile(HOME,'thirdparty','matlabPyrTools','MEX'));
addpath(fullfile(HOME,'thirdparty','OpticalFlowCe'));
addpath(fullfile(HOME,'thirdparty','OpticalFlowCe','mex'));
addpath(fullfile(HOME,'thirdparty','ParforProgMon'));
javaaddpath(fullfile(HOME,'thirdparty','ParforProgMon'));
addpath(fullfile(HOME,'thirdparty','sift'));
addpath(fullfile(HOME,'transform'));
addpath(fullfile(HOME,'util'));
addpath(fullfile(HOME,'video'));
addpath(fullfile(HOME,'video','converter'));
addpath(fullfile(HOME,'video','qtime'));
addpath(fullfile(HOME,'vision'));
addpath(fullfile(HOME,'visualization'));

fprintf('Matlab Toolbox successfully installed. (c) Michael Rubinstein, MIT\n');
