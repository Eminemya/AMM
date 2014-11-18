if ~exist('done_init','var')
    if ismac
        addpath(genpath('lib'))
    end
    if isunix
        addpath(genpath('../lib'))
    end
    addpath('util')
    DLIB= '/data/vision/billf/donglai-lib/VisionLib/Donglai/';
    addpath(genpath([DLIB 'Low/Flow/CeOF/']))
    addpath(genpath([DLIB 'Util']))
    addpath(genpath([DLIB 'Low/Flow/Deqing']));
    addpath('T_p2v')
    addpath('P_amp')
    addpath('P_motion')
    addpath('P_pdic')
    addpath('T_flow')
    done_init=1;
    set(0,'DefaultFigureWindowStyle','docked')
end
