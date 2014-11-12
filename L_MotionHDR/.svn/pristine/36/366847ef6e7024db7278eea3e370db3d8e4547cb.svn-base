%% Test script to see if we can do adaptive noise cancellation correctly
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

p = 10;
w = zeros(p+5,p)/(p);
y = zeros(size(d));
mu = 0.001;
for n = p+3:N-p-1
   y(n) = convn(x(n-p:n-1), w(n,:), 'valid');
   e(n) = y(n)-x(n);
   xT = x(n-1:-1:n-p);   
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

