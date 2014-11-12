%% Try to replicate chapters 3 and 4 of Bayesian Spectral Analysis book

trials = 1e3;
N = 512;
omega1 = 2*pi*0.145;
omega2 = 2*pi*0.15;
sigma = 1;
A1 = sqrt(2);
A2 = sqrt(3);
estimates = zeros(trials,2);
for k = 1:trials
    k
    phi1 = rand()*2*pi;
    phi2 = rand()*2*pi;
    
    t = -N:N;
    data = A1*cos(omega1*t+phi1) + A2*cos(omega2*t+phi2) + randn(size(t))*sigma;
    data = data-mean(data);
    %% Compute estimates
    obj_func = @(w) -twoFreqFuncGenerator(w,data,t);
    temp = fminsearch(obj_func, [0.5, 0.5]);
    estimates(k,:) = temp;


end
%% Histograms
close all
figure('Position', [1 1 800 400]);
subplot(1,2,1);
hist(estimates(:,1));
subplot(1,2,2);
hist(estimates(:,2));
%% Plot objective
figure();
[x,y] = meshgrid(linspace(0.7,1,200), linspace(0.7,1,200));
for k = 1:size(x,1)
    for j = 1:size(x,2)
        spice(k,j) = obj_func([x(k,j), y(k,j)]);
    end
end
imagesc(spice); colorbar;