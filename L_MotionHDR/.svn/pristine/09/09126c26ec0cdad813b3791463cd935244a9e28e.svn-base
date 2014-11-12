%% Bandpass (matches)
fl = 1;
fh = 3;
fs = 30;
n = 4;
[Z, P, K] = butter(n, 2*[fl/fs, fh/fs]);
[SOS] = zp2sos(Z,P,K)


%% Lowpass (matches filterDesign Code)
fl =2;
fs = 30;
n = 2;
[Z, P, K] = butter(2, 2*fl/fs);
[SOS] = zp2sos(Z,P,K)