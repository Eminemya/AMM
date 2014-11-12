%% Test script to see if we can do adaptive filtering with gaussian filter
% using Wang et al.'s method of FFTing
% signal will be sinusoid, noise will be IID AWGN
% Neal Wadhwa, February 2014

clear;
close all;

N = 3e2;
P = 20;
n = 0:N;
sigman = 1;

d = sin(2*pi/10*n);
v = sigman*randn(size(d));
x = d + v;


q = 20;
p = 2*q + 1;

sigma2(q+3) = 16;
n = q + 3;
w = exp(-(-q:q).^2./(2*sigma2(n))).*1/sqrt(2*pi*sigma2(n));


y = zeros(size(d));
mu = 1;

for n = q+3:N-q-1
   xT = x(n-q:n+q);   
   [~, I] = max(abs(fft(xT)));
   sigma2(n) = 2*pi/I;
   w = exp(-(-q:q).^2./(2*sigma2(n))).*1/sqrt(2*pi*sigma2(n));
   y(n) = convn(xT, w, 'valid');                    
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
