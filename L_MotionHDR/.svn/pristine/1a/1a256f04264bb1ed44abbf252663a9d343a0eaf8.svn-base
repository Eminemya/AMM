% Let's try and simulate simonceill's optical flow model from this thesis
% and see what we get 

%
% Neal Wadhwa, October 2014

clear;
close all;

%% Test 1
% Given the time derivative, some uncertainty about the time derivative,
% and the space derivative, what's the distribution of the velocity?
% Phase constancy: phit = phis \cdot v

gt = [0.4; 0.2];
thetas = [0, pi/4, pi/2, 3*pi/4];
phis = [cos(thetas); sin(thetas)];
phit = sum(bsxfun(@times, phis, gt),1);
phit_SD = [0.1, 0.5, 3, 0.01];


figure('Position', [ 1 1 1000 1000]);
for k = 1:numel(thetas)
    subplot(2,2,k);
    u = linspace(-1,1,300);
    v = linspace(-1,1,300);
    [UU,VV] = meshgrid(u,v);
    pdf{k} = exp(-(phis(1,k)*UU+phis(2,k)*VV-phit(k)).^2/(2*phit_SD(k).^2));
    pdf{k} = pdf{k}./sum(pdf{k}(:));
    imagesc(u,v,pdf{k});
    xlabel('x velocity');
    ylabel('y velocity');
    title(sprintf('PDF (Velocity Space) - Orientation: %d degrees', round(180/pi*thetas(k))));
    % Uncertainity only in time derivative, assumes known spatial derivative,
    % and accurate phase constancy equation
end
% pdfs are degenerate!, infinte variance in one direction

    
%% Inversion plus - estimation of original velocity plus variances
% We can get the pdfs from what we know, so we will assume that as input

% Simple strategy, assume noise in different phit are independent. Is that
% true??
jointPDF = pdf{1}.*pdf{2}.*pdf{3}.*pdf{4};
jointPDF = jointPDF./sum(jointPDF(:));
figure();
title('Joint PDF (Empirical)');
imagesc(u,v,jointPDF);
xlabel('x velocity');
ylabel('y velocity');
title('Joint PDF');

% analytic computation of covariance matrix
temp1 = bsxfun(@rdivide, phis, (phit_SD));
temp2 = phit./(phit_SD);
V = diag(sum(temp1.^2,2)); % Variances
V(1,2) = sum(temp1(1,:).*temp1(2,:));
V(2,1) = V(1,2); % Covariances
D = sum(temp2.*temp1(1,:));
E = sum(temp2.*temp1(2,:));
mu = V\[D;E];

T = [UU(:)-mu(1) VV(:)-mu(2)];
jointPDFAnalytic = sum((T*V).*T,2);
jointPDFAnalytic = reshape(jointPDFAnalytic, size(UU));
jointPDFAnalytic./sum(jointPDFAnalytic(:));

figure(); 
title('Joint PDF (analytic)');
imagesc(exp(-1/2*jointPDFAnalytic));
xlabel('x velocity');
ylabel('y velocity');



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Let's test our assumptions

%% Independence of noise assumption 
% Just noise 
%examples = 1e3;
%for k = 1:examples
%   S = randn(13,13);
%  values(k,:) = cell2mat(buildG4H4pyr(S, 1,1,thetas));
%end
% not independent
%figure();
%imagesc(abs(corr(values)))

% Noise plus image content
[x,y] = meshgrid((0:12)/13, (0:12)/13);
image = cos(2*pi*3*x)+cos(2*pi*3*y);
noiselessVal = angle(cell2mat(buildG4H4pyr(image,1, 1,thetas)));
clear values;
for k = 1:examples
   S = 0.1*randn(13,13)+image;
   values(k,:) = mod(pi+angle(cell2mat(buildG4H4pyr(S, 1,1,thetas)))-noiselessVal,2*pi)-pi;
end
% not indepndent
figure();
imagesc(abs(corr(values)))
%% Certainity of spatial derivative (instaneous frequency)
% if the spatial derivative were constant in a band, then the distribution
% of spatial gradients would be a delta function or at least sharply peaked
% Test on a real video
vr = VideoReader('~/Downloads/guitar.avi');
frame = mean(im2single(vr.read(1)),3);
A = buildG4H4pyr(frame, 1, 1, thetas);
mask = A{1} > 0.2; % get rid of low amplitude points since these don't fit out model
Sx = imag(convn(A{1}, [1 -1],'same')./(A{1}+eps));
Sy = imag(convn(A{1}, [1 -1]','same')./(A{1}+eps));
figure();
subplot(1,2,1);
hist(Sx(idx), 100);
xlabel('Phase Gradient x');
title('Quantity');

subplot(1,2,2);
hist(Sy(idx), 100);
xlabel('Phase Gradient y');
title('Quantity');
% Even without noise, a single band in a single frame has many different
% spatial gradients
% This isn't so bad, we can just use the true spatial gradient rather than
% the average value

%% What about sensitivy to noise?

interestingPoint = [52, 55];
interestingBit = frame(52+(-10:10), 55+(-10:10));
examples = 3e3;
noiseSigma = 0.01;
checkPt = [6, 7];
% Compute true values
   current = interestingBit;
   A = buildG4H4pyr(current,1,1,thetas);
   Sx = imag(convn(A{1}, [1 -1],'same')./(A{1}+eps));
   Sy = imag(convn(A{1}, [1 -1]','same')./(A{1}+eps));
   trueVal(1) = Sx(checkPt(1), checkPt(2));
   trueVal(2) = Sy(checkPt(1), checkPt(2));

for k = 1:examples
   current = interestingBit + randn(size(interestingBit))*noiseSigma;
   A = buildG4H4pyr(current,1,1,thetas);
   Sx = imag(convn(A{1}, [1 -1],'same')./(A{1}+eps));
   Sy = imag(convn(A{1}, [1 -1]','same')./(A{1}+eps));
   val(k,1) = Sx(checkPt(1), checkPt(2));
   val(k,2) = Sy(checkPt(1), checkPt(2));
end
figure();
subplot(1,3,1);
hist(val(:,1),100);
xlabel('Phase Gradient x');
title('Marginal Distribution x');

subplot(1,3,2);
hist(val(:,2),100);
xlabel('Phase Gradient y');
title('Marginal Distribution y');


subplot(1,3,3);
scatter(val(:,1)-trueVal(1), val(:,2)-trueVal(2));
xlabel('Phase Gradient x');
ylabel('Phase Gradient y');
title('Samples from joint distribution');
% Gaussian distribution, also not very certain

% Spatial gradient being known assumption is not accurate






















