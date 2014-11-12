trials = 2.5e3;
N = 512;
omega = 2*pi*0.05;
sigma = 1;
A = sqrt(2);
t = 1:N;
M = 2*pi*0.01;
amplitudes = abs(cos(M*t)+1e-2);

estimates = zeros(trials,1);
for k = 1:trials
    k
    phi = rand()*2*pi;
    
    t = 1:N;
    data = A*cos(omega*t+phi)+randn(size(t))*sigma./amplitudes;
    data = data-mean(data);
    % Compute estimate
    obj_func = @(w) -abs(sum(amplitudes.^2.*data.*exp(1i*w*t))).^2./sum(amplitudes.^2);
%    fplot(obj_func, [omega/2, 3*omega/2], 1e4);
    %pause(0.01);
    
    [temp ~, exitflag] = fminbnd(obj_func, omega-0.05, omega+0.05);
    estimates(k) = temp;
end
estimates = estimates(abs(estimates-omega)<3);

%% Plotting stuff
figure();
plot(data)
figure();
plot(data.*amplitudes.^2);
figure();
fplot(@(x) -obj_func(x), [0.05, pi]);

figure();
hist(estimates,50)


