function wMed = weightedMedian(D,W)

% ----------------------------------------------------------------------
% Function for calculating the weighted median 
% Sven Haase
%
% For n numbers x_1,...,x_n with positive weights w_1,...,w_n, 
% (sum of all weights equal to one) the weighted median is defined as
% the element x_k, such that:
%           --                        --
%           )   w_i  <= 1/2   and     )   w_i <= 1/2
%           --                        --
%        x_i < x_k                 x_i > x_k
%
%
% Input:    D ... matrix of observed values
%           W ... matrix of weights, W = ( w_ij )
% Output:   wMed ... weighted median                   
% ----------------------------------------------------------------------


if nargin ~= 2
    error('weightedMedian:wrongNumberOfArguments', ...
      'Wrong number of arguments.');
end

if size(D) ~= size(W)
    error('weightedMedian:wrongMatrixDimension', ...
      'The dimensions of the input-matrices must match.');
end

% normalize the weights, such that: sum ( w_ij ) = 1
% (sum of all weights equal to one)

WSum = sum(W, 2);
W = W./repmat(WSum, [1 size(W,2)]);

% (line by line) transformation of the input-matrices to line-vectors

% sort the vectors
wMed = zeros(size(W,1),1);
for k = 1:size(W,1)
    d = D(k,:);
    w = W(k,:);
   
    A = [d' w'];
    ASort = sortrows(A,1);

    dSort = ASort(:,1)';
    wSort = ASort(:,2)';

    sumVec = cumsum(wSort);  % vector for cumulative sums of the weights

    
    j = 0;         
    [~, I] = min(abs(sumVec-0.5));
    wMed(k) = dSort(I);
end


% final test to exclude errors in calculation
%if ( sum(wSort(1:j-1)) > 0.5 ) & ( sum(wSort(j+1:length(wSort))) > 0.5 )
%     error('weightedMedian:unknownError', ...
%      'The weighted median could not be calculated.');
end