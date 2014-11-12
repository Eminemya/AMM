%% We want to see what happens when the phase measurements don't agree
% Is the covariance matrix enough to characterize the diagreement? I feel
% like no, since it doesn't depend on the time characteristic


%
clear;
close all;

gt = [0.4; 0.2];
thetas = [0, pi/4, pi/2, 3*pi/4];
phis = [cos(thetas); sin(thetas)];
%phit = sum(bsxfun(@times, phis, gt),1);
phit = [0.6014    0.0620    0.4152    0.3476]; % random perturbation of above
phit_SD = [0.1, 0.1, 0.1, 0.1];


figure('Position', [ 1 1 1000 1000]);
for k = 1:numel(thetas)
    subplot(2,2,k);
    u = linspace(-1,1,300);
    v = linspace(-1,1,300);
    [UU,VV] = meshgrid(u,v);
    pdf{k} = exp(-(phis(1,k)*UU+phis(2,k)*VV-phit(k)).^2/(2*phit_SD(k).^2));
    
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
jointPDF = jointPDF./max(jointPDF(:));
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
%{
figure(); 
title('Joint PDF (analytic)');
imagesc(exp(-1/2*jointPDFAnalytic));
xlabel('x velocity');
ylabel('y velocity');
%}

%% Contour lines
val = exp(-1/2);
CC = jet(7);
figure();

for j =1:4;
    contour(u,v,pdf{j},[val,val],'color', CC(j,:)); hold on;
end
contour(u,v,jointPDF, [val, val], 'color', 'red');
xlabel('x velocity');
ylabel('y velocity');
title('Joint PDF');
% So, covariance matrix is localized, but the joint PDF doesn't agree with
% 3 of the Gaussians
% What are the posterior probabilties?
for k = 1:4
    1/(sqrt(2*pi)*phit_SD(k)).*exp(-(phis(1,k)*mu(1)+phis(2,k)*mu(2)-phit(k)).^2/(2*phit_SD(k).^2))
end
% really low for 2 of them
