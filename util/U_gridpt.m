function [ball_ind,pt] = U_gridpt(sz,ballSpacing)
%ballSpacing = 10;


mat_ind = reshape(1:prod(sz(1:2)),sz(1:2));

ball_ind = reshape(mat_ind(ballSpacing:ballSpacing:end,ballSpacing:ballSpacing:end),[],1);
pt=[];
if nargout==2
    [yy,xx] = meshgrid(1:sz(2),1:sz(1));
    pt = [yy(ball_ind) xx(ball_ind)];
end

