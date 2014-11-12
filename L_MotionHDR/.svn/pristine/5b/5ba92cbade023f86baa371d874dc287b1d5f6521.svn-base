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
phis_SD = [0.1, 0.5, 3, 0.01];

figure('Position', [ 1 1 1000 1000]);
examples = 1e3;
for k = 1:numel(thetas)
    subplot(2,2,k);
    u = linspace(-1,1,300);
    v = linspace(-1,1,300);
    [UU,VV] = meshgrid(u,v);
    pdf{k} = exp(-(phis(1,k)*UU+phis(2,k)*VV-phit(k)).^2./(2*(1+UU.^2+VV.^2)*phit_SD(k).^2));
    pdf{k} = pdf{k}./sum(pdf{k}(:));
    imagesc(u,v,pdf{k});
    xlabel('x velocity');
    ylabel('y velocity');
    title(sprintf('PDF (Velocity Space) - Orientation: %d degrees', round(180/pi*thetas(k))));
    % Uncertainity only in time derivative, assumes known spatial derivative,
    % and accurate phase constancy equation
end
% pdfs are not Gaussian! It may not matter that the space gradients are
% uncertain. 

%% 
jointPDF = pdf{1}.*pdf{2}.*pdf{3}.*pdf{4};
jointPDF = jointPDF./sum(jointPDF(:));
figure();
title('Joint PDF (Empirical)');
imagesc(u,v,jointPDF);
xlabel('x velocity');
ylabel('y velocity');
title('Joint PDF');