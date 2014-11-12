trials = 5e3;
N = 3000;
omega = 2*pi*0.05;
sigma = 1;
A = sqrt(2);

[x, y] = meshgrid(linspace(-30:10, -30:30));



esimates = zeros(trials,1);
for k = 1:trials
    k
    phi = rand()*2*pi;
    
    t = 1:N;
    data = A*cos(omega*t+phi)+randn(size(t))*sigma;
    data = data-mean(data);
    % Compute estimate
    obj_func = @(w) - 1./numel(t).*abs(sum(data.*exp(1i*w*t))).^2;
%    fplot(obj_func, [omega/2, 3*omega/2], 1e4);
    %pause(0.01);
    
    [temp ~, exitflag] = fminbnd(obj_func, omega-0.05, omega+0.05);
    estimates(k) = temp;
end
estimates = estimates(abs(estimates-omega)<3);