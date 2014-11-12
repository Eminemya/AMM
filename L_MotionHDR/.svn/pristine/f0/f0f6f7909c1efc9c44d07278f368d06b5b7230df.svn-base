clear;
close all;

sigma = randn(4,1)
theta =randn(4,1)
CC  =cos(theta);
SS = sin(theta);

%% NEal's way
covN = inv([sum(CC.^2./sigma.^2) sum(CC.*SS./sigma.^2); sum(CC.*SS./sigma.^2) sum(SS.^2./sigma.^2)]);


%% Donglai's way
B = inv([sum(CC.^2) sum(CC.*SS); sum(CC.*SS) sum(SS.^2)]);
D = [sum(CC.^2.*sigma.^2) sum(CC.*SS.*sigma.^2); sum(CC.*SS.*sigma.^2) sum(SS.^2.*sigma.^2)];
covD = B*D*B;

covN

covD