% For a given frequency sinusoid, what is the best way to compute the
% amplitude of a Hilbert transform

clear;
close all;

fs = 30; 
t = 1/fs:1/fs:4;
omega = 1;
y = sin(2*pi*omega*t);

figure();
plot(t,y)
hold on;
plot(t,y.^2);
