function out = txt2vid(texts, bgColor, txtColor, txtWidth, varargin)
    if nargin<2 | isempty(bgColor)
        bgColor = [0,0,0];
    end
    if nargin<3 | isempty(txtColor)
        txtColor = [1,1,1];
    end
    
    for k = 1:numel(texts)
        temp{k} = txt2im(texts{k}, bgColor, txtColor, txtWidth, varargin{:});
    end
    H = max(cellfun(@(x) size(x,1), temp));
    W = max(cellfun(@(x) size(x,2), temp));
    out = zeros(H,W,size(temp{1},3), numel(texts),'uint8');
    for k = 1:numel(texts)
       [h,w,nC] = size(temp{k});
       diffH = floor((H-h)/2);
       diffW = floor((W-w)/2);       
       out(diffH+(1:h), diffW+(1:w), :,k) = temp{k};                
    end
    
    
    
    

end