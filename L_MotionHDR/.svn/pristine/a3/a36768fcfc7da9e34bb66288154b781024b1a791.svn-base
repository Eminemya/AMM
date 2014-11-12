%% Test script to see if we can do adaptive filtering with gaussian filter
% solving for optimal sigma every time
% signal will be sinusoid, noise will be amplitude dependent variance
% Neal Wadhwa, February 2014

clear;
close all;

N = 1e2;
P = 20;
n = 0:N;
sigman = 1;
sigmaA = 10;

amp = exp(-(n-fix(N/2)).^2/(2*sigmaA.^2))+1e-1;
d = sin(2*pi/10*n);
v = sigman*randn(size(d))./amp;
x = d + v;


q = 10;
p = 2*q + 1;

sigma2(q+3) = 16;
n = q + 3;
w = exp(-(-q:q).^2./(2*sigma2(n))).*1/sqrt(2*pi*sigma2(n));

% solve for initial sigma2
wspice = @(sss) exp(-(-q:q).^2./(2*sss)).*1/sqrt(2*pi*sss);
xT = x(n+q:-1:n-q);  
espice = @(sss) convn(x(n-q:n+q), wspice(sss),'valid')-x(n+q+1);
wDspice = @(sss) wspice(sss).*((-q:q).^2./(2*sss^2)-1/(2*sss));
obj_func_spice = @(sss) -espice(sss).*sum(xT.*wDspice(sss));
numTries = 50;
fVal = Inf;
%{
sss = 16;
interval = [0 10];
for k = 1:numTries
    init = rand()*(interval(2)-interval(1))+interval(1);
    [out_x, tempVal] = fminunc(obj_func_spice, init);    
    if (tempVal < fVal)
        sss = out_x;
    end
    [out_x, tempVal] = fminbnd(obj_func_spice, interval(1), interval(2));
    
    if (tempVal < fVal)
        sss = out_x;
    end
end
%}
sss = fzero(obj_func_spice,1);
sigma2(1:q+3) = sss;

w = exp(-(-q:q).^2./(2*sigma2(n))).*1/sqrt(2*pi*sigma2(n));
y = zeros(size(d));
mu = 10;
for n = q+3:N-q-1
   y(n) = convn(x(n-q:n+q), w, 'valid');
   e(n) = y(n)-x(n+q+1);
   
   xT = x(n+q:-1:n-q);   
   wD = w.*((-q:q).^2./(2*sigma2(n)^2)-1/(2*sigma2(n)));
   
   change = (e(n) * sum(wD.*xT));
   
   
   change = min(mu*change.^2,sigma2(n)).*sign(change);
   
   sigma2(n+1) = sigma2(n) - change;
   
    w = exp(-(-q:q).^2./(2*sigma2(n))).*1/sqrt(2*pi*sigma2(n));
    
end
%% Solve Weiner-Hopf equations
A  = xcorr(x,x);
A = A(1:N+1);
weights = [1:N+1];
A = A./weights;
A = fliplr(A);
M = p;
[XX, YY] = meshgrid(0:M-1, 0:M-1);
idx = abs(XX-YY)+1;
R = A(idx);


B = xcorr(d,x);
B = B(1:N+1);
B = B./weights;
B = fliplr(B);
idx = [ 1:p] + 1;
rdx =  B(idx)';
w_weiner = R\rdx; % What w should converge to
y_weiner = conv(x, w_weiner, 'same');


%% Plot
figure('Position', [1 1 640 480]);
plot(x)
hold on;
plot(d, 'g');
plot(y,'r');
xlabel('Time');

figure('Position', [1280 1 640 480]);
plot(x)
hold on;
plot(d, 'g');
plot(y_weiner,'r');
xlabel('Time');


figure('Position', [ 1 480 640 480]);
plot(sigma2)
xlabel('Time');

figure('Position', [ 640 480 640 480]);
plot(w_weiner); hold on;
plot(w(end,:),'r');
legend({'Theoretical', 'Empirical'}, 'Location', 'Best');

figure('Position', [ 640 1 640 480]);
plot(abs(fft(w_weiner,1e3))); hold on;
plot(abs(fft(w(end,:),1e3)),'r');
legend({'Theoretical', 'Empirical'},'Location', 'Best');

figure('Position', [1280 480 640 480]);
plot(abs(fft(w,1e3)))
hold on;
T = abs(fft(d,1e3));
T = T./max(T);
plot(T, 'g');
xlabel('Frequency');
