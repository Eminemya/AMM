%% Let's see what a few different auto gain strategies do for sinusoids in the prescense of some noise
% Neal Wadhwa, Oct 2
clear;
close all;
figDir = mfilename;
mkdir(figDir);
t = linspace(0,5,100);
alpha = 0.1;
noiseSigma = 0.003;
A = cat(2,linspace(1,0,numel(t)/2),linspace(0,1,numel(t)/2));
%A = linspace(-1,1,numel(t));
signal{1} = alpha.*A.*sin(2*pi*t);
signal{2} = signal{1}+randn(size(signal{1}))*noiseSigma;

figure();
captions = {'Perfect', 'Noisy', 'Denoised'};
for j = 1:2
    subplot(2,1,j);
    plot(t,signal{j});
    title(captions{j});
    xlabel('Time (s)')
    ylabel('Motion (px)');
    ylim([-1.1 1.1]);
end
% Target is to get all motion to 1px
saveas(gcf, fullfile(figDir, 'original.eps'), 'epsc');


%% Just multiply by 1 over alpha
for j = 1:2
    out{j} = 1/alpha*signal{j};
end
figure();
for j = 1:2
    subplot(2,1,j);
    plot(t,out{j});
    title(captions{j});
    ylim([-1.1 1.1]);
end

saveas(gcf, fullfile(figDir, 'control.eps'), 'epsc');

%% Compute hilbert transform, set amplitude to 1 px

maxVal = 1;
for j = 1:2
    amp = abs(hilbert(signal{j}));
    out{j} = signal{j}./amp*maxVal;
end
figure();
for j = 1:2
    subplot(2,1,j);
    plot(t,out{j});
    title(captions{j});
    ylim([-1.1 1.1]);
end


saveas(gcf, fullfile(figDir, 'hilbert.eps'), 'epsc');







