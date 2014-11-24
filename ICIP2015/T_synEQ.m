fprintf('1. create signal')

ff= [100 150 200 250];amp= [10 5 2 1];
ff= [100 200];amp= [10 3];
amp_n = 0.5;
num_s = 300;
ff_w = 5;
signal0 = amp_n*randn(1,num_s);
bump = 1-((-ff_w:ff_w).^2)/(ff_w^2);
for i=1:numel(ff)
    f= ff(i);
    signal0(f-ff_w:f+ff_w) = signal0(f-ff_w:f+ff_w)+amp(i)*bump;
end
signal = [signal0 signal0(end:-1:2)];

%{
% checking signal
figure(1),subplot(211),cla,plot(signal,'b-')
% linear phase
signal2 = real(ifft(hilbert(signal)));
%signal2 = real(ifft(hilbert(signal)));

signal3 = abs(fft(signal2));

figure(1),subplot(212),cla,plot(signal2)
figure(1),subplot(211),hold on,plot(1:numel(signal3),signal3,'rx')
%}
fprintf('2. alpha estimation')
[sig,mu]=T_noise(signal,1);


eid =1;
switch eid
    case 1
        amp = signal0./(signal0+mu);
        signal_out = amp.*signal0;
    case 2
        % not a good prior
        % gaussian mrf
        % diagonal element + smoothness
        sm_sig = 10;
        xind = [1:num_s reshape(repmat(1:num_s-1,2,1),1,[])];
        yind = [1:num_s reshape([1:num_s-1;2:num_s],1,[])];
        vind = [ones(1,num_s) sm_sig*reshape([ones(1,num_s-1);-ones(1,num_s-1)],1,[])];
        A = sparse(xind,yind,vind,num_s*2-1,num_s);
        b = [signal0 zeros(1,num_s-1)]';
        x0 = (A\b)';
        figure(2),subplot(211),cla,plot(x0,'b-')
        figure(2),subplot(211),hold on,plot(signal0,'r-')
        figure(2),subplot(212),cla,plot(signal0-x0,'b-')
    case 3
        % mode decomposition
end
%{
  idx = pyrBandIndices(pind, l);
      timeAmplitude = abs(HilbertM(phases(idx,:),2));
      spaceAmplitude = abs(pyr(idx,:)).^2;
      noiseCurrent = noiseLevel.^2./spaceAmplitude;
      timeAmplitude2 = MLEPhase(timeAmplitude.^2, noiseCurrent);
      alpha = maxPixLevels(l).*(sqrt(timeAmplitude2)./(timeAmplitude2+noiseCurrent));
%}
