%% Comparison of Filters
% List of filters tried:
% Causal Butterworth filter (only looks at past value) 
% Butterworth filter applied forward and backwards ( to kill phase
% response)
% causal FIR filter with Kaiser window
% FIR filter with Kaier wndow with no phase response
% Zeroing out in frequency domain

figDir = mfilename;
mkdir(figDir);

N = 200;
t = (0:(N-1));
w1 = pi*0.1133;
w2 = pi*0.125;
signal = sin(w1*t)+sin(w2*t);
truth = signal;
signal = signal + 0.1*randn(size(signal));
fl = 0.09;
fh = 0.16;

%% IIR - Butterworth
[B, A] = butter(4, [fl fh]);
out = filter(B,A, signal);

[Ha{1}, Wa{1}] = freqz(B,A);
figure('Position', [1 1 600 300], 'PaperPositionMode', 'auto');
plot(signal);
hold on;
plot(truth, 'g', 'LineWidth', 2);
plot(out,'r--','LineWidth', 2);
xlim([50 150])
xlabel('Time (samples)');
legend({'Input', 'Truth', 'Filtered'});
ylabel('Motion');
title('IIR Butterworth');

error(1) = sqrt(mean((out-truth).^2));

saveas(gcf, fullfile(figDir, 'IIRButterworth.eps'), 'psc2');

%% IIR Butterworth - With delay
[B, A] = butter(4, [fl fh]);
out = filter(B,A, signal);
[Ha{2}, Wa{2}] = freqz(B,A);
[H, W] = freqz(B,A);
phaseResponse =interp1(W/pi, unwrap(angle(H)), w2);
delay = abs(ceil(phaseResponse./w1));
out = [zeros(1,delay) out(1:end-delay)];
Ha{2} = Ha{2}.*exp(1i*phaseResponse*Wa{2});
figure('Position', [1 1 600 300], 'PaperPositionMode', 'auto');;
plot(signal);
hold on;
plot(truth, 'g', 'LineWidth', 2);
plot(out,'r--','LineWidth', 2);
xlim([50 150])
xlabel('Time (samples)');
legend({'Input', 'Truth', 'Filtered'});
ylabel('Motion');
title('IIR Butterworth with Delay');

error(2) = sqrt(mean((out-truth).^2));

saveas(gcf, fullfile(figDir, 'IIRButterworthWithDelay.eps'), 'psc2');

%% Forwards and Backwards
[B, A] = butter(4, [fl, fh]);
out = filtfilt(B,A, signal);


[Ha{3}, Wa{3}] = freqz(B,A);
Ha{3} = abs(Ha{3});
figure('Position', [1 1 600 300], 'PaperPositionMode', 'auto');;
plot(signal);
hold on;
plot(truth, 'g', 'LineWidth', 2);
plot(out,'r--','LineWidth', 2);
xlim([50 150])
xlabel('Time (samples)');
legend({'Input', 'Truth', 'Filtered'});
ylabel('Motion');
title('IIR Butterworth Forwards/Backwards');
error(3) = sqrt(mean((out-truth).^2));

saveas(gcf, fullfile(figDir, 'IIRButterworthForwardBackward.eps'), 'psc2');

%% FIR - Kaiser
n = 100;
B = fir1(n, [fl, fh], kaiser(n+1, 4));
out = filter(B,1, signal)

[Ha{4}, Wa{4}] = freqz(B,1);
figure('Position', [1 1 600 300], 'PaperPositionMode', 'auto');;
plot(signal);
hold on;
plot(truth, 'g', 'LineWidth', 2);
plot(out,'r--','LineWidth', 2);
xlim([50 150])
xlabel('Time (samples)');
legend({'Input', 'Truth', 'Filtered'});
ylabel('Motion');
title('FIR Kaier Window');

error(4) = sqrt(mean((out-truth).^2));

saveas(gcf, fullfile(figDir, 'FIRKaiser.eps'), 'psc2');

%% FIR filter with delay
n = 100;
B = fir1(n, [fl, fh], kaiser(n+1, 4));
out = convn(signal,B,'same')

[Ha{5}, Wa{5}] = freqz(B,1);
Ha{5} = abs(Ha{5});

figure('Position', [1 1 600 300], 'PaperPositionMode', 'auto');;
plot(signal);
hold on;
plot(truth, 'g', 'LineWidth', 2);
plot(out,'r--','LineWidth', 2);
xlim([50 150])
xlabel('Time (samples)');
legend({'Input', 'Truth', 'Filtered'});
ylabel('Motion');
title('FIR Kaiser Window with Delay');

error(5) = sqrt(mean((out-truth).^2));



saveas(gcf, fullfile(figDir, 'FIRKaiserDelay.eps'), 'psc2');


%% Frequency Domain zeroing

freq = linspace(0,2,N);
mask = double(freq>fl) .* double(freq <fh);
out = real(ifft(mask.*fft(signal))*2);

B = real(ifft(mask)*2);
[Ha{6}, Wa{6}] = freqz(B,1);
Ha{6} = abs(Ha{6});
figure('Position', [1 1 600 300], 'PaperPositionMode', 'auto');;
plot(signal);
hold on;
plot(truth, 'g', 'LineWidth', 2);
plot(out,   'r--','LineWidth', 2);
xlim([50 150])
xlabel('Time (samples)');
legend({'Input', 'Truth', 'Filtered'});
ylabel('Motion');
title('Frequency Domain zeroing');

error(6) = sqrt(mean((out-truth).^2));

saveas(gcf, fullfile(figDir, 'FreqDomainZeroing.eps'), 'psc2');




%% Make Videos
videos{1} = fullfile(figDir, 'input.avi');

outS{2} = fullfile(figDir, 'IIRButterworth.avi');
outS{3} = fullfile(figDir, 'IIRButterworthWithDelay.avi');
outS{4} = fullfile(figDir, 'IIRButterworthForwardBackward.avi');
outS{5} = fullfile(figDir, 'FIRKaiser.avi');
outS{6} = fullfile(figDir, 'FIRKaiserDelay.avi');
outS{7} = fullfile(figDir, 'FreqDomainZeroing.avi');

videos{8} = fullfile(figDir, 'Truth.avi');

captions = {'Input', 'Butter', 'Butter Delay', 'Butter For/back', 'Kaiser', 'Kaiser Delay', 'Freq Zero', 'Truth'};

filters = {0, @FilterButter4, @FilterButter4Delay, @FiltFiltButter4, @FilterKaiser101, @FilterKaiser101Delay, @IdealBP, 0};

alpha =20;



im = imread('marker.png');
im = 1-rgb2y(im2single(im));
vid = mkImageSignalVid(im, 0.1*[signal', zeros(200,1)]);
vid = vid+randn(size(vid))*0.01;
writeVideo(im2uint8(vid),10,videos{1});

vid = mkImageSignalVid(im, alpha*0.1*[truth', zeros(200,1)]);
vid = vid+randn(size(vid))*0.01;
writeVideo(im2uint8(vid),10,videos{8});

for j  = 2:7
   videos{j} = fullfile(figDir, phaseAmplify(videos{1}, alpha, fl, fh, 2,  figDir, 'temporalFilter', filters{j}));
   vidgridMJPEG(videos([1 8 j]), captions([1 8 j]), outS{j});
end



4
vidgridMJPEG(videos, captions, fullfile(figDir, 'allcomparison.avi'), [2 4]);

%% Baby
vidFile = fullfile(getRootDir(), 'babysleeping.avi');
vidNames{1} = vidFile;
alpha = 10;
fl = 0.5;
fh = 3;
fs = 30;
filters = {@FilterButter4, @FiltFiltButter4, @FilterKaiser101Delay, @IdealBP};
for j = 1:4
    vidNames{j+1} = fullfile(figDir, phaseAmplify(vidFile, alpha, fl , fh, fs, figDir, 'temporalFilter', filters{j},'sigma', 3));
end
captions = {'Input', 'Butter', 'Forward/Backward Butter', 'Kaiser101', 'Freq. Zeroing'};
vidgridMJPEG(vidNames, captions, fullfile(figDir, 'babyComparison.avi'), [2 3], 0.5);





%% Comparison of magnitude and phase responses
%{
colors = jet(6);
figure();
hold on;
for j = 1:6
    plot(Wa{j}/pi, (abs(Ha{j})), 'Color', colors(j,:));    
end
xlim([0.05 0.2]);
%}