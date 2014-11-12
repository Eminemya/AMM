function [X,Y, H1, H2] = lowFrequency(w)
    t = 0:99;
    X = cos(w*t);
    Y = sin(w*t);
    Z = [X; Y] ;
    a = sum(X.^2);
    b = sum(Y.^2);
    c = sum(X.*Y);
    
    M = [a c; c b];
    [V, D] = eig(M);
    H = V*Z;
    H1 = 1/sqrt(D(1,1))*H(1,:);
    H2 = 1/sqrt(D(2,2))*H(2,:);
    
    
end

