function out = singleTxt2vid(texts, bgColor, txtColor, nF, txtWidth, varargin)
    if nargin<2 | isempty(bgColor)
        bgColor = [0,0,0];
    end
    if nargin<3 | isempty(txtColor)
        txtColor = [1,1,1];
    end
    
    
    temp = txt2im(texts, bgColor, txtColor, txtWidth, varargin{:});
    out = repmat(temp, [1 1 1 nF]);
    
    
    
    

end