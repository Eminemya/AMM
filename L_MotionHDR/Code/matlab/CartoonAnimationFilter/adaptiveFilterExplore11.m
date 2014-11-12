%% Test script to see if we can do weiner filter with a Gaussian
% Assumptions are that the signal is narrowband while noise is broadband
% 
% Neal Wadhwa, February 2014

clear;
close all;

N = 1e4;
P = 20;
n = 0:N;
sigman = 1;

figDir = mfilename;
mkdir(figDir);


A = [0 0 1];
p = rand(4,1)*2*pi;
d = A(1)*sin(2*pi/1e3*40*n+p(1)) + A(2)*sin(2*pi/1e3*20*n+p(2)) + A(3)*sin(2*pi/1e3*10*n+p(3));
v = sigman*randn(size(d));
x = d + v;

q = 60;
p = q + 1;
w = zeros(p+5,p)/(p);
y = zeros(size(d));
mu = 0.001;
for n = q+3:N-q-1
   y(n) = convn(x(n-q:n), w(n,:), 'valid');
   e(n) = y(n)-x(n+1);
   xT = x(n:-1:n-q);   
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


B = xcorr(x,x);
B = B(1:N+1);
B = B./weights;
B = fliplr(B);
idx = [ 1:p] + 1;
rdx =  B(idx)';
w_weiner = R\rdx; % What w should converge to
y_weiner = conv(x, w_weiner, 'full');


%% Plot
ff = figure('Position', [1 1 640 320],'PaperPositionMode','auto');
plot(x,'b');
hold on;
plot(d, 'g','LineWidth', 2);
plot(y_weiner,'r--', 'LineWidth', 2);
xlabel('Time (samples)');
xlim([0 300]);
legend({'Noisy', 'Ground Truth', 'Denoised'}, 'Location', 'Best');
saveas(ff, fullfile(figDir, 'timeDomain.eps'), 'psc2');

ff = figure('Position', [1 1 640 320],'PaperPositionMode','auto');
M = 5e3;
plot(linspace(0,1001,M), abs(fft(x,M)),'b');
hold on;
plot(linspace(0,1001,M), abs(fft(d,M)), 'g','LineWidth', 2);
plot(linspace(0,1001,M), abs(fft(y_weiner,M)),'r--', 'LineWidth', 2);
xlabel('Frequency (samples)');
xlim([0 200]);
legend({'Noisy', 'Ground Truth', 'Denoised'}, 'Location', 'Best');
saveas(ff, fullfile(figDir, 'freqDomain.eps'), 'psc2');


ff = figure('Position', [1 1 640 320],'PaperPositionMode','auto');
plot(w_weiner,'b');
xlabel('Time (samples)');
xlim([1 numel(w_weiner)]);
saveas(ff, fullfile(figDir, 'impulseResponse.eps'),'psc2');