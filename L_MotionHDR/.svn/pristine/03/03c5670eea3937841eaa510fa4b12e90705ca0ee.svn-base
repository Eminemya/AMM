%% 
trials = 1e3;
N = 512;
omega1 = 2*pi*0.05;
alpha = 0.01;
sigma = 0.1;
A1 = sqrt(2);

estimates = zeros(trials,2);
for k = 1:trials
    
    phi1 = rand()*2*pi;
    phi2 = rand()*2*pi;
    
    t = 1:N;
    data = A1*cos(omega1*t+phi1).*exp(-alpha*t)+ randn(size(t))*sigma;
    data = data-mean(data);
    %% Compute estimates
    obj_func = @(w) -abs(sum(data.*exp(1i*w(1)*t).*exp(-w(2)*t))./sqrt(1/2*(1-exp(-2*N*w(2)))./(exp(2*w(2))-1))).^2;
    [out] = fminsearch(obj_func,[omega1, alpha]);
    estimates(k,:) = out;


end


%% Plot obj
[x,y] = meshgrid(linspace(0,1,100), linspace(0,1,100));
for k = 1:size(x,1)
    for j = 1:size(x,2)
        spice(k,j) = obj_func([x(k,j), y(k,j)]);
    end
end