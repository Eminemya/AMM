function [sig,mu]=T_noise(signal,opt)
% 1D signal noise estiation
if ~exist('opt','var');opt=1;end
    switch opt
    case 1
        % iterative method
        dif = 10;
        ind = ones(1,numel(signal));
        sig = 0;
        while dif>5
            mu = median(signal(ind));
            sig = std(signal,1);
            dif= nnz(ind);
            ind = abs(signal-mu)<1*sig;
            dif= dif-nnz(ind);
            nnz(ind)
        end
    case 2
    end
