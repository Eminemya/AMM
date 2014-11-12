trials = 5e3;
N = 300;
omega = 2*pi*0.001;
sigma = 1;
A = sqrt(2);

esimates = zeros(trials,1);
for k = 1:trials
    k
    phi = rand()*2*pi;
    
    t = 1:N;
    data = A*cos(omega*t+phi)+randn(size(t))*sigma;
    data = data-mean(data);
    % Compute estimate
    
    
    obj_func = @(w) lowFreqFuncGenerator(w, data, t);
%    fplot(obj_func, [omega/2, 3*omega/2], 1e4);
    %pause(0.01);
    
    [temp ~, exitflag] = fminsearch(@(w) -obj_func(w), omega);
    estimates(k) = temp;
end
estimates = estimates(abs(estimates-omega)<3);

%% Plotting stuff
close all;
figure();
fplot(obj_func, [0, pi], 5e4);
xlim([0 1]);
figure();
hist(estimates, 20);
fprintf('Sample std. dev is %0.4f\n', std(estimates));
fprintf('Predicted std. dev is %0.4f\n', sigma./A.*sqrt(48./N^3));
fprintf('Width of rectangular window is %0.4f\n', 1./N);