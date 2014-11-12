%% Try to create an Eulerian cartoon animation filter on a synthetic disk
% Neal Wadhwa, February 2014
clear;
close all;

path = [linspace(0,40,100)' zeros(100, 1)];
path = cat(1,zeros(25,2), path, cat(2,ones(25,1)*40, zeros(25,1)));
vid = mkPathDiskVid(path, 'diskCenter', [60 80]);
vid = vid +  0.01*randn(size(vid));

[buildPyr, reconPyr] = octave4PyrFunctions(size(vid,1),size(vid,2));
%[phases, ~, pind] = computePhases(vid, buildPyr);
for k = 1:size(path,1)
    [temp, pind] = buildPyr(vid(:,:,1,k));
    phases(:,k) = angle(temp);
    amps(:,k) = abs(temp);
end

phaseVids = pyrVid2CellVid(phases, pind);
ampVids = pyrVid2CellVid(amps, pind);

%% Derivatives
clear kernel;
clear gaussKernelT;
kernel(1,1,1,:) = [1 -2 1];
sigma = 3;
N = 3*sigma;
gaussKernel = exp(-(-N:N).^2./(2*sigma.^2));
gaussKernel = gaussKernel./sum(gaussKernel);
gaussKernelT(1,1,1,:) = gaussKernel;
temp = unwrap(phaseVids{2}, [] ,4 );
temp1 = mod(pi+convn(temp, kernel,'same'),2*pi)-pi;
temp2 = mod(pi+convn(temp1, gaussKernelT,'same'),2*pi)-pi;

%% Try to understand automatic temporal frequency selection
dKernel(1,1,1,:) = [-1 1];
for k = 17 %16:size(path,1)-16
   S = abs(fft(mod(pi+convn(temp(:,:,:,k-15:k+16), dKernel, 'valid'),2*pi)-pi, [], 4));
   T = abs(fft(convn(temp(:,:,:,k-15:k+16), 1, 'same'), [], 4));
end
[~, I1] = max(S,[],4);
[~, I2] = max(T,[],4);

%X = convn(squeeze(temp(80,60,1,:)),[1 -1]', 'valid');
X = squeeze(temp(80,60,1,:));
Y = X(11:42);
Z = abs(fft(Y));
Z = Z(1:16);
Z = Z.*sin(linspace(0,pi/2,16))';
figure();
plot(Z)


%% Amplification
%{
temp = unwrap(phases, [], 2);
kernel = [-1 2 -1];
temp = mod(pi+convn(temp, kernel, 'valid'),2*pi)-pi;
temp1 = zeros(size(phases));
temp1(:,2:end-1) = temp;
temp = temp1;
temp = mod(pi+convn(temp, gaussKernel, 'same'), 2*pi)-pi;
idx = pyrBandIndices(pind, 2);
temp(1:idx(1)-1,:) = 0;
idx = pyrBandIndices(pind, size(pind,1));
temp(idx(1):end,:) = 0;
alpha = 50;
for k = 1:size(path,1)
    out(:,:,1,k) = reconPyr(amps(:,k).*exp(1i*(phases(:,k)+alpha*temp(:,k))), pind);
end
%}