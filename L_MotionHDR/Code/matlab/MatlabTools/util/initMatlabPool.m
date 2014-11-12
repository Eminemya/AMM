function nCores = initMatlabPool(nCores,config,homeDir)
% Initializes the MATLAB threadpool
%   nCores - number of cores to use (must be <= available cores)
%   config - name of parallel configuration
%   homeDir - path to code directory
%   
% TODO: what happens if changing scheduler?

if exist('nCores','var') ~= 1
    nCores = []; % will use all available workers
end
if exist('config','var') ~= 1
    config = 'local';
end
if exist('homeDir','var') ~= 1
    homeDir = fileparts(mfilename('fullpath')); % pwd
end

if nCores == 0 & matlabpool('size') > 0
    matlabpool close;
    return;
end

schd = findResource('scheduler','configuration',config);
if nCores > schd.ClusterSize
    error('Number of workers (%d) larger than cluster size (%d)',nCores,schd.ClusterSize);
end
if isempty(nCores)
    nCores = schd.ClusterSize;
end

if matlabpool('size') ~= schd.ClusterSize
    if matlabpool('size') > 0
        matlabpool close;
    end
    
    v = matlabVersion;
    if v >= 7.12
        matlabpool(schd,nCores,'FileDependencies',{fullfile(homeDir,mfilename)});
    else    
        matlabpool(config,nCores,'FileDependencies',{fullfile(homeDir,mfilename)});
    end

    % initialize workers
    % assumes a function setPath.m in home directory
    parfor i = 1:nCores
        addpath(homeDir);
        SetPath;
    end
end
