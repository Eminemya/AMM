function vid = mkSinConstrained(orients, amp, complexModulation)

N = 100;
wx = 12*cos(orients);
wy = 12*sin(orients);
if (nargin < 3)
    w = wx+wy;
   complexModulation = w(:);
end
t = 1:100;
wt = 0.05;
motion = 1/12*amp*exp(1i*2*pi*wt*t);
complexModulation = complexModulation(:);
p = real(bsxfun(@times, motion,  complexModulation));
vid = mkMultiFrameSin(N,wx,wy,p);
end