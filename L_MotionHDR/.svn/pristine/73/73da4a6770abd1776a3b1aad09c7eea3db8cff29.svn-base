figDir = mfilename;
mkdir(figDir);



%% Single Point with Gravity

c = 330; % speed of sound
center = [-33 0];
lambda = 0.03; % Time extent of sound
omega = 440; %Hz
Amp = 1;
gravity = 0;
v0 = 0; % m/s (0.5 px/frame)
spice = @(t,y) soundWavePacketGravity(t,y,c, center(1), center(2), omega/c, lambda*c, Amp, gravity, v0);
t = 0.000:0.0001:0.1;
[~,path{k}] = ode113(spice, t, [-.05 0]);
figure();
firstA = @(x) x(1);
fplot(@(y) firstA(spice(0.00, [y 0])),[-10 10]);
hold on;
plot([-0.1 0.1], [0 0], 'g','LineWidth', 2);
xlabel('Space (m)');
title('Acoustic Velocity (x) at time t=0');
ylabel('Velocity (m/s)');


saveas(gcf, fullfile(figDir, 'velvsspace.eps'), 'psc2');

figure();
fplot( @(t) firstA(spice(t, [-0.05 0])), 100*[0 1e-3],1e4);
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Acoustic Velocity (x) at origin');
saveas(gcf, fullfile(figDir, 'velvstime.eps'), 'psc2');

figure();
plot(t, path{k}(:,1)); hold on;
xlabel('Time (s)');
title('Position (X) of particle starting at origin');
ylabel('Position (m)');
saveas(gcf, fullfile(figDir, 'lagrangeVelX.eps'), 'psc2');

figure();
plot(t, -path{k}(:,2)); hold on;
xlabel('Time (s)');
title('Position (Y) of particle starting at origin');
ylabel('Position (m)');
saveas(gcf, fullfile(figDir, 'lagrangeVelY.eps'), 'psc2');



%% Render
particleList = synthSeedParticles('xDensity',75,'yDensity', 75, 'canvasSize', [0.2 0.5], 'canvasCenter', [0 -0.2]);
spice = @(t,y) soundWavePacketGravity(t,y,c, center(1), center(2), omega/c, lambda*c, Amp, gravity, v0);
particleListPath = synthComputePaths2(particleList, t, spice, 1);
range = 301:500;

% particle diameter 2mm (4px)
particleSize = 0.0005;
out = renderParticleListPath(particleListPath(range,:,:), 1, 1, 'viewSize', [0.2 0.1], 'pixelHeight', 256,'particleSize', particleSize);
videos{1} = fullfile(figDir, sprintf('gravityWave-pSize%0.6f.avi', particleSize));
writeVideo(out, 20, videos{1});

% particle diameter 4mm (8 px)
particleSize = 0.001;
out = renderParticleListPath(particleListPath(range,:,:), 1, 1, 'viewSize', [0.2 0.1], 'pixelHeight', 256,'particleSize', particleSize);
videos{2} = fullfile(figDir, sprintf('gravityWave-pSize%0.6f.avi', particleSize));
writeVideo(out, 20, videos{2});

% particle diameter 8mm (16 px)
particleSize = 0.002;
out = renderParticleListPath(particleListPath(range,:,:), 1, 1, 'viewSize', [0.2 0.1], 'pixelHeight', 256,'particleSize', particleSize);
videos{3} = fullfile(figDir, sprintf('gravityWave-pSize%0.6f.avi', particleSize));
writeVideo(out, 20, videos{3});



%% Motion Magnification
% Filter accelerations
fs = 2;
sigma = 3;
fh = 0;
alpha = 400;
for j = 3:-1:1
   phaseAmplify2(videos{j}, alpha, sigma, fh, fs, figDir, 'temporalFilter', @FilterAccel01);
end

% Filter jerk
fs = 2;
sigma = 3;
fh = 0;
alpha = 800;
for j = 3:-1:1
   phaseAmplify2(videos{j}, alpha, sigma, fh, fs, figDir, 'temporalFilter', @FilterJerk01);
end


% Filter accelerations and frequency range
fs = 1e4;
fl = 300;
fh = 600;
alpha = 400;

for j = 3:-1:1
   phaseAmplify2(videos{j}, alpha, fl, fh, fs, figDir, 'temporalFilter', @FilterAccelFreq);
end















