if ~exist('done_init','var')
    if ismac
        addpath(genpath('lib'))
    end
    if isunix
        addpath(genpath('../lib'))
    end
    addpath('util')
    addpath('T_p2v')
    addpath('P_amp')
    addpath('P_motion')
    addpath('T_flow')
    done_init=1;
    set(0,'DefaultFigureWindowStyle','docked')
end
