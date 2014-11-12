%% Script to make figures showing what is going on with the small on large motion
% Neal Wadhwa, February 2014

% Init
clear;
close all
figDir = mfilename;
mkdir(figDir);


%% Make video
v = 1; %px/frame
omega = 20; 
A = 0.1;
t = 0 : 100;

oscillation = A*cos(omega*t*2*pi/100);
ramp = -50 + t*v;
path = ramp + oscillation;
path = [path' zeros(size(path,2),1)];
vid = mkPathDiskVid(path,'diskSize', 1);
vid = vid + randn(size(vid))*0.01;

%%  Show overall path
ff = figure('Position', [1 1 500 150], 'PaperPositionMode', 'auto');

plot(t, path(:,1));
xlim([0 100]);
xlabel('Time (frames)');
ylabel('Displacement (px)');
pts = [80 40; 80 100];
colors = {'cyan', 'blue'};
hold on;
% label points we will show later
scatter(0, pts(1,2)-80,100, colors{1}, 'fill');
scatter(0, pts(2,2)-80,100, colors{2}, 'fill');
legend({'Ramp + Oscillation', 'Point 1', 'Point 2'},'Location', 'NorthWest');
legend boxoff;
saveas(ff, fullfile(figDir, 'path.eps'), 'psc2');
%% Build Pyramids
[buildPyr,~] = octave4PyrFunctions(size(vid,1), size(vid,2));
[phases, pyrs, pind] = computePhasesNoRef(vid, buildPyr);
%phases = mod(pi+convn(phases, [1 -1],'valid'),2*pi)-pi;
%phases = cumsum(phases,2);
phases = pyrVid2CellVid(phases, pind);
pyrs = (pyrVid2CellVid(abs(pyrs), pind));

%% plot some Eulerian points
level = 2;

for k = 1:size(pts,1)
    eulerPath{k}  = -unwrap(squeeze(phases{level}(pts(k,1), pts(k,2),1,:)));
    amps{k} = squeeze(pyrs{level}(pts(k,1), pts(k,2),:));
    ff = figure('Position', [1 1 500 300], 'PaperPositionMode', 'auto');
    plot(t, eulerPath{k}, colors{k});
    xlim([0 100]);
    xlabel('Time (frames)');
    ylabel('Displacement (Radians)');
    saveas(ff, fullfile(figDir, sprintf('eulerPath%d.eps',k)), 'psc2');
end

%% LoG Filter

for k = 1:size(pts,1)
    eulerPathF{k}  = applyFilter1D(eulerPath{k}, @(x) FilterAccel01(x,1,0));
    %eulerPathF{k} = convn(eulerPath{k}, [-1 2 -1]','same');
    ff = figure('Position', [1 1 500 300], 'PaperPositionMode', 'auto');
    plot(t, eulerPathF{k}, colors{k});
    hold on;    
    plot(t,oscillation, 'r');
    plot(t,amps{k}*4, 'g--');
    xlim([0 100]);
    xlabel('Time (frames)');
    ylabel('Displacement (Radians)');
    legend({'Phase Signal', 'Ground Truth', 'Amplitude'});
    saveas(ff, fullfile(figDir, sprintf('eulerPathLoG%d.eps',k)), 'psc2');
end

