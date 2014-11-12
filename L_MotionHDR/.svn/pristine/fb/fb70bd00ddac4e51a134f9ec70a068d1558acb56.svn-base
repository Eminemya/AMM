trials = 5e3;
N = 300;
omega = 2*pi*0.05;
sigma = 1;
A = sqrt(2);

esimates = zeros(trials,1);
for k = 1:trials
    
    phi = rand()*2*pi;
    
    t = 1:N;
    data = A*cos(omega*t+phi)+randn(size(t))*sigma;
    data = data-mean(data);
    % Compute estimate
    obj_func = @(w) - 1./numel(t).*abs(sum(data.*exp(1i*w*t))).^2;
%    fplot(obj_func, [omega/2, 3*omega/2], 1e4);
    %pause(0.01);
    
    [temp, ~, exitflag] = fminsearch(obj_func, omega);
    estimates(k) = temp;
end
estimates = estimates(abs(estimates-omega)<3);



%% Plotting stuff
omega
figure();
fplot(obj_func, [0, pi], 5e3);
xlim([0 1]);
figure();
hist(estimates, 50);
fprintf('Sample std. dev is %0.4f\n', std(estimates));
fprintf('Predicted std. dev is %0.4f\n', sigma./A.*sqrt(48./N^3));
fprintf('Width of rectangular window is %0.4f\n', 1./N);