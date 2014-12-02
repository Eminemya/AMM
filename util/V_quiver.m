function h=V_quiver(flo,ballSpacing)
sz = size(flo);
pt_ind=U_gridpt(sz,ballSpacing);

[yy,xx] = meshgrid(1:sz(2),1:sz(1));

xx=flipud(xx);
%flo(:,:,2)=flipud(flo(:,:,2));

pt = [yy(pt_ind),xx(pt_ind)];
flo_i = reshape(flo,[],2);
h=quiver(pt(:,1),pt(:,2),flo_i(pt_ind,1),flo_i(pt_ind,2),'Color','k','LineWidth',1,'AutoScale','off');