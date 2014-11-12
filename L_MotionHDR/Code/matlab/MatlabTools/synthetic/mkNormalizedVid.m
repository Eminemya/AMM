function [ normalizedVid ] = mkNormalizedVid( inputVid, varargin )
    p = inputParser();
    
    defaultInputRange = [min(inputVid(:)), max(inputVid(:))];
    defaultOutputRange = [0 1];
    
    addOptional(p, 'inputRange', defaultInputRange);
    addOptional(p, 'outputRange', defaultOutputRange);
    
    parse(p,varargin{:});
    
    inputRange = p.Results.inputRange;
    outputRange = p.Results.outputRange;
    
    inputVid = (inputVid - inputRange(1))./(inputRange(2)-inputRange(1));
    normalizedVid = inputVid.*(outputRange(2)-outputRange(1))+outputRange(1);


end

