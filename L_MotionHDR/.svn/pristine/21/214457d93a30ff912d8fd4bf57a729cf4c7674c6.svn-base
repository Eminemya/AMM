function [ smoothPhase ] = smoothPhaseSignal( phase, amp, lambda2 )
%SMOOTHPHASESIGNAL Summary of this function goes here
%   Detailed explanation goes here

    [m,n,t] = size(phase);
    smoothPhase= zeros(size(phase), 'single');
    currentAmp = amp'.^2;
    % diagonal term
    i = [(1:m*n)'];
    j = [(1:m*n)'];
    s = double([currentAmp(:)]);
    T = sparse(i,j,s,m*n,m*n);


    S = gallery('poisson', n);
    S = S(1:m*n, 1:m*n)*lambda2;
    S = S+ T;
    for k = 1:t;

        currentFrame = phase(:,:,k)';      
        b = double(currentAmp(:).*currentFrame(:));
        out =S\b;
        smoothPhase(:,:,k) = single(reshape(out, [n, m])');

    end
end

