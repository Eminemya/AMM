vidName = 'pipe_original';
rootDir = fullfile(getRootDir(), 'Vidmag2', 'Data');
vidFile = fullfile(rootDir, [vidName '.avi']);

vr = VideoReader(vidFile);
vid = vr.read();
vid = rgb2y(im2single(vid));

%% Init
[h, w, nC, nF] = size(vid);
[buildPyr, reconPyr] = octave4PyrFunctions(h, w);
[phases, pyrs, pind] = computePhases(vid, buildPyr, 1);
phases = pyrVid2CellVid(phases, pind);
pyrs = pyrVid2CellVid(pyrs, pind);




%% Fourier stuff
level = 8;
fs = 20000;
amps = mean(abs(pyrs{level}),4);
spice = bsxfun(@times, abs(fft(phases{level},[],4)).^2, amps.^2);
spice2 = squeeze(mean(mean(spice,1),2));
figure();
freq = linspace(0,fs,nF);
start = 10;
plot(freq(start:end), spice2(start:end));
xlim([0 1e4]);

%% Actual DTFT
obj_func = @(phases{level}
spice = bsxfun(@times, abs(fft(phases{level},[],4)).^2, amps.^2);

