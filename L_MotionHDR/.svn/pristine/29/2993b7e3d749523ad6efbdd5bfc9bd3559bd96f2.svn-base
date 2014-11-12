function [ out ] = lowFreqFuncGenerator(w, data, time )
    G1 = cos(w*time);
    G2 = sin(w*time);
    Z = [G1;G2];
    a = sum(G1.^2);
    b = sum(G2.^2);
    c = sum(G1.*G2);
    M = [a c; c b];
    [V, D] = eig(M);
    H = V*Z;
    H1 = 1/sqrt(D(1,1))*H(1,:);
    H2 = 1/sqrt(D(2,2))*H(2,:);

    h1 = sum(data.*H1);
    h2 = sum(data.*H2);
    out = h1.^2+h2.^2;


end

