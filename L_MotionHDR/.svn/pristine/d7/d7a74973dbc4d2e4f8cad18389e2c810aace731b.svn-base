%% Let's see what a few different auto gain strategies do for sinusoids in the prescense of some noise
% Neal Wadhwa, Oct 2
clear;
close all;
figDir = mfilename;
mkdir(figDir);
t = linspace(0,5,100);
alpha = 0.1;
noiseSigma = 0.001;
signal{1} = alpha*sin(2*pi*t);
signal{2} = signal{1}+randn(size(signal{1}))*noiseSigma;
[B,A] = butter(2, [0.07 0.17]);
signal{3} = filter(B,A,signal{2});
figure();
captions = {'Perfect', 'Noisy', 'Denoised'};
for j = 1:3
    subplot(3,1,j);
    plot(signal{j});
    title(captions{j});
end
% Target is to get all motion to 1px
figure('Position', [1 1 1000 300], 'PaperPositionMode', 'auto');
plot(t,signal{3});
title('Original Signal');
xlabel('Time (s)');
ylabel('Displacement (px)');
ylim([-1.1 1.1]);
saveas(gcf, fullfile(figDir, 'original.eps'), 'epsc');


%% Just multiply by 1 over alpha
for j = 1:3
    out{j} = 1/alpha*signal{j};
end
figure();
for j = 1:3
    subplot(3,1,j);
    plot(out{j});
    title(captions{j});
end
figure('Position', [1 1 1000 300], 'PaperPositionMode', 'auto');
plot(t,out{3});
title('Multiplication Signal');
xlabel('Time (s)');
ylabel('Displacement (px)');
ylim([-1.1 1.1]);
saveas(gcf, fullfile(figDir, 'control.eps'), 'epsc');

%% Set all values to 1 px, preserve sign
maxVal = 1;
for j = 1:3
    out{j} = signal{j}./abs(signal{j})*maxVal;
end
figure();
for j = 1:3
    subplot(3,1,j);
    plot(out{j});
    title(captions{j});
end
figure('Position', [1 1 1000 300], 'PaperPositionMode', 'auto');
plot(t,out{3});
title('Normalize by Value');
xlabel('Time (s)');
ylabel('Displacement (px)');
ylim([-1.1 1.1]);
saveas(gcf, fullfile(figDir, 'strategy1.eps'), 'epsc');
%% Compute hilbert transform, set amplitude to 1 px

maxVal = 1;
for j = 1:3
    amp = abs(hilbert(signal{j}));
    out{j} = signal{j}./amp*maxVal;
end
figure();
for j = 1:3
    subplot(3,1,j);
    plot(out{j});
    title(captions{j});
end
figure('Position', [1 1 1000 300], 'PaperPositionMode', 'auto');
plot(t,out{3});
title('Normalize by Hilbert Transform');
xlabel('Time (s)');
ylabel('Displacement (px)');
ylim([-1.1 1.1]);
saveas(gcf, fullfile(figDir, 'strategy2.eps'), 'epsc');










