clear;
close all;


func = @processAutoGain001;

figDir = mfilename;
mkdir(figDir);

load(fullfile(figDir, 'names.mat'));


%% Crane
rootDir = '~/Downloads/Vidmag2/Data/release/';
vidName = 'crane_crop.avi';
vv  = fullfile(rootDir, vidName);
fl = 0.2;
fh = 0.4;
fs = 24;
maxPix = 3; %4 px
alpha = 50;
sigma = 2;
ind = 1;
outName{ind} = func(vv, maxPix, sigma, fl, fh, fs, figDir);


%% Guitar
rootDir = '~/Downloads/Vidmag2/Data/';
vidName = 'guitar.avi';
vv  = fullfile(rootDir, vidName);
fl = 72;
fh = 92;
fs = 600;
maxPix = 3; %4 px
alpha = 25;
sigma = 2;
ind = 2;
outName{ind} = func(vv, maxPix, sigma, fl, fh, fs, figDir);


%% Baby

rootDir = '~/Downloads/Vidmag2/Data/release/';
vidName = 'baby.avi';
vv  = fullfile(rootDir, vidName);
fl = 0.5;
fh = 3;
fs = 30;
maxPix = 3; %4 px
alpha = 10;
sigma = 2;
ind = 3;
outName{ind} = func(vv, maxPix, sigma, fl, fh, fs, figDir);


%% Camera
rootDir = '~/Downloads/Vidmag2/Data/release/';
vidName = 'camera.avi';
vv  = fullfile(rootDir, vidName);
fl = 3.6;
fh = 9.3;
fs = 30;
maxPix = 3; %4 px
alpha = 60;
sigma = 2;
ind = 4;
outName{ind} = func(vv, maxPix, sigma, fl, fh, fs, figDir);
%% Bowed Violin
fl = 340; % Acually 196Hz
fh = 370;
fs = 5602;
alpha = 100; 
sigma = 2;

maxPix = 3; %4 px
vv = fullfile('~/Downloads', 'Vidmag2/Data/freqSweeps', ['bowedViolin_f1000-1300.avi']);
ind = 5;
outName{ind} = func(vv, maxPix, sigma, fl, fh, fs, figDir);

%% Column 

fl = 78;
fh = 82;
alpha = 30;
fs = 1500;
sigma = 2;
tfilt = @FiltFiltButter;
vidName = 'test08_t50-70';
maxPix = 3; %4 px
vv = fullfile('~/Downloads', 'Civil/Data/', [vidName '.avi']);
ind = 6;

outName{ind} = func(vv, maxPix, sigma, fl, fh, fs, figDir);


%% Smoke
fl = [9];
fh = [15];
fs = 200;
alpha = [25];
sigma = 3;
maxPix = 3; %4 px
vidName = 'smoke04_w240_f1-300';
vv = fullfile('~/Downloads/', 'Vidmag2/Data/freqSweeps', [vidName '.avi']);
ind = 7;
outName{ind} = func(vv, maxPix, sigma, fl, fh, fs, figDir);

%% Corner Brace

%% Save
save(fullfile(figDir, 'names.mat'), 'outName');


