clear;
close all;
particleList = synthSeedParticles('xDensity', 10,'yDensity', 10, 'canvasSize', [1 3]);
c = 2;
center = [-1 0];
lambda = 0.3;
omega = 5;
Amp = 0.01;
damping = 0;
gravity = 0.1;
spice = @(t,y) soundWavePacket(t,y,c, center(1), center(2), omega, lambda, Amp);
t = 0.01:0.01:1.5;



solvers = { @ode113};
colors = jet(6+2);
figure();
firstA = @(x) x(1);
fplot(@(y) firstA(spice(5, [y 0])),[0 20]);

figure();
amps = rand(1e2,1)*0.1;

colors = jet(numel(amps)+2);
for k = 1:numel(amps)
    amp = amps(k);
    spice = @(t,y) soundWavePacket(t,y,c, center(1), center(2), omega, lambda, amp);
    [~,path{k}] = solvers{1}(spice, t, [0 0]);
    plot(path{k}(:,:),'Color', colors(k,:)); hold on;
    ENDPoint(k) = path{k}(end,1);
end
figure();
scatter(amps, ENDPoint);
pause(0.1);
%% Single Point
c = 330; % speed of sound
center = [-0.05 0];
lambda = 0.03; % Time extent of sound
omega = 220; %Hz
Amp = 1;
spice = @(t,y) soundWavePacket(t,y,c, center(1), center(2), omega/c, lambda*c, Amp);
t = 0.000:0.0001:0.1;
[~,path{k}] = ode113(spice, t, [-0.0025 -0.0048]);
figure();
firstA = @(x) x(1);
fplot(@(y) firstA(spice(0.00, [y 0])),[-20 20]);
xlabel('Space (m)');
figure();
fplot( @(t) firstA(spice(t, [0 0])), 1000*[0 1e-3],1e4);
xlabel('Time (s)');
figure();
plot(t, path{k}(:,1)); hold on;
xlabel('Time (s)');

%% Render
particleList = synthSeedParticles('xDensity',100,'yDensity', 100, 'canvasSize', [0.2 0.1]);
particleList = particleList + 0.001*randn(size(particleList));
spice = @(t,y) soundWavePacket(t,y,c, center(1), center(2), omega/c, lambda*c, Amp);
particleListPath = synthComputePaths(particleList, t, spice, 10);


out = renderParticleListPath(particleListPath(1:400,:,:), 1, 1, 'viewSize', [0.2 0.1], 'pixelHeight', 200,'particleSize', 0.001);



%% Single Point with Gravity

c = 330; % speed of sound
center = [-0.05 0];
lambda = 0.03; % Time extent of sound
omega = 220; %Hz
Amp = 1;
gravity = 10;
v0 = 1.8;
spice = @(t,y) soundWavePacketGravity(t,y,c, center(1), center(2), omega/c, lambda*c, Amp, gravity, v0);
t = 0.000:0.0001:0.1;
[~,path{k}] = ode113(spice, t, [-0.0025 -0.0048]);
figure();
firstA = @(x) x(1);
fplot(@(y) firstA(spice(0.00, [y 0])),[-20 20]);
xlabel('Space (m)');
figure();
fplot( @(t) firstA(spice(t, [0 0])), 1000*[0 1e-3],1e4);
xlabel('Time (s)');
figure();
plot(t, path{k}(:,1)); hold on;
plot(t, path{k}(:,2),'g'); hold on;
xlabel('Time (s)');
%% Render
particleList = synthSeedParticles('xDensity',100,'yDensity', 100, 'canvasSize', [0.2 0.2]);
particleList = particleList + 0.001*randn(size(particleList));
spice = @(t,y) soundWavePacketGravity(t,y,c, center(1), center(2), omega/c, lambda*c, Amp, gravity, v0);
particleListPath = synthComputePaths(particleList, t, spice, 1);


out = renderParticleListPath(particleListPath(1:400,:,:), 1, 1, 'viewSize', [0.2 0.1], 'pixelHeight', 200,'particleSize', 0.001);



%% Render all ponts
c = 2;
center = [-1 0];
lambda = 0.3;
omega = 5;
spice = @(t,y) soundWavePacket(t,y,c, center(1), center(2), omega, lambda, Amp);
t = 0.01:0.01:1.5;

particleList = synthSeedParticles('xDensity',2,'yDensity', 2, 'canvasSize', [10 30]);
spice = @(t,y) soundWavePacket(t,y,c, center(1), center(2), omega, lambda, 0.001);
particleListPath = synthComputePaths(particleList, t, spice, 100);

out = renderParticleListPath(particleListPath, 1, 1, 'viewSize', [10 10], 'pixelHeight', 400, 'particleSize', 0.1);


%% AMp = 0.1
clear;
close all;
particleList = synthSeedParticles('xDensity', 10,'yDensity', 10, 'canvasSize', [1 3]);
c = 2;
center = [-1 0];
lambda = 0.1;
omega = 10;
Amp = 0.1;
damping = 0;
gravity = 0.1;
spice = @(t,y) soundWavePacketGravity(t,y,c, center(1), center(2), omega, lambda, damping, Amp, 0.1);
t = 0.01:0.01:1.5;



solvers = { @ode113};
colors = jet(numel(solvers)+2);
figure();
for k = 1:numel(solvers)
    
    [~,path{k}] = solvers{k}(spice, t, [0 0.5 3 0]);
    plot(path{k}(:,:),'Color', colors(k,:)); hold on;
end

pause(0.1);
initVelocity = [0 0.5];
particleListPath = synthComputePaths(particleList, t, spice, initVelocity);

for k = 1:numel(t)    
    out(:,:,1,k) = renderParticleList(squeeze(particleListPath(k,:,:)));
end
writeVideo(out,25, fullfile('SoundAmp0.1.avi'));

