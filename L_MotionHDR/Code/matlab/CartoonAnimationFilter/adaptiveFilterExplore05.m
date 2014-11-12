%% Test script to see how recursive least squares performs
% with a non causal filter in the noise cancellation framework
% should be possible if we compare y to a time-delayed or advanced verison
% of x beyond the scope of the filter
% using recursive least squares instead of LMS algorithm
% signal will be sinusoid, noise will be IID AWGN
% Neal Wadhwa, February 2014

clear;
close all;

N = 1e4;
P = 20;
n = 0:N;
sigman = 1;

d = sin(2*pi/10*n);
v = sigman*randn(size(d));
x = d + v;


q = 10;
p = 2*q + 1;
w = zeros(p+5,p)/(p);
y = zeros(size(d));
mu = 0.001;
for n = q+3:N-q-1
   y(n) = convn(x(n-q:n+q), w(n,:), 'valid');
   e(n) = y(n)-x(n+q+1);
   xT = x(n+q:-1:n-q);   
   w(n+1,:) = w(n,:) - mu * xT./(norm(xT)+eps)*e(n); % Normalized gradient descent
    
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
imagesc(w');
xlabel('Time');

figure('Position', [ 640 480 640 480]);
plot(w_weiner); hold on;
plot(w(end,:),'r');
legend({'Theoretical', 'Empirical'}, 'Location', 'Best');

figure('Position', [ 640 1 640 480]);
plot(abs(fft(w_weiner,1e3))); hold on;
plot(abs(fft(w(end,:),1e3)),'r');
legend({'Theoretical', 'Empirical'},'Location', 'Best');
