function u=T_p2v(frame,frame2,psz_h,orientations,bandIDX)
% 1 orientation and 1 scale

sz =size(frame);
[buildPyr,~] = U_octphase(sz(1), sz(2),orientations);

[pyr, pind] = buildPyr(frame);
pyr2 = buildPyr(frame2);

fprintf('Process Level %d\n',bandIDX);
currentBand = pyrBand(pyr,pind, bandIDX);
currentBand2 = pyrBand(pyr2,pind, bandIDX);

phi1 = U_unwrap2d(angle(currentBand));
phi2 = U_unwrap2d(angle(currentBand2));
% unwrap
phit = mod(pi+angle(currentBand2)-angle(currentBand),2*pi)-pi;

% L2 regression
%u=T_lk_p3(phi1,phi2,psz_h,1,phit);
% robust regression
[phix,phiy] = gradient(phi1);
phix_p = im2col(padarray(phix,[psz_h psz_h],'replicate'),[2*psz_h+1 2*psz_h+1]);
phiy_p = im2col(padarray(phiy,[psz_h psz_h],'replicate'),[2*psz_h+1 2*psz_h+1]);
phit_p = im2col(padarray(phit,[psz_h psz_h],'replicate'),[2*psz_h+1 2*psz_h+1]);
u = zeros(2,size(phix_p,2));
parfor i=1:size(phix_p,2)
    tmp = robustfit([phix_p(:,i) phiy_p(:,i)],phit_p(:,i));
    %{
    clf
    plot3(phix_p(:,i),phiy_p(:,i),phit_p(:,i),'b.')
    hold on;
    points=[[phix_p(1,i),phiy_p(1,i),tmp(1)+[phix_p(1,i),phiy_p(1,i)]*tmp(2:3)]; ...
            [phix_p(5,i),phiy_p(5,i),tmp(1)+[phix_p(5,i),phiy_p(5,i)]*tmp(2:3)]; ...
            [phix_p(end,i),phiy_p(end,i),tmp(1)+[phix_p(end,i),phiy_p(end,i)]*tmp(2:3)]];
    ind = [1 2 3];
    plot3(points(:,1),points(:,2),points(:,3),'rx')
    fill3(points(:,1),points(:,2),points(:,3),'r'),alpha(0.1)
    %}
    u(:,i) =tmp(2:3);
end
u=reshape(u',[sz 2]);

