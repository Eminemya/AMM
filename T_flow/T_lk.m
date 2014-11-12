function [u,V]=T_lk(f1,f2,max_iter)
% 2D: 1 motion vector
if ~exist('max_iter','var')
    max_iter = 1e3;
end
f2(isnan(f2))=0;
f1(isnan(f1))=0;
tolF = 1e-5;
tolx = 1e-4;
iter = 0;
sz =size(f1);
dif = inf;
delta = dif;

switch sz(1)
    case 1
        % 1D
        Ix = gradient(f1);
        Ix_2 = Ix.^2;
        xx = 1:numel(f1);
        u = 0;
        while dif > tolF && iter<max_iter && delta> tolx
            % only evaluate valid
            ind = find(xx+u>=xx(1)&xx+u<=xx(end));
            It = interp1(xx,f2,xx(ind)+u)-f1(ind);
            delta = dif;
            dif = norm(It);
            delta = abs(dif-delta);
            du = -sum(Ix(ind).*It)/sum(Ix_2(ind));
            u = u+du;
            %disp([u dif])
            %keyboard
            iter= iter+1;
        end
    case 2
        % 2D
        [Ix,Iy] = gradient(f1);
        Ix_2 = Ix.^2;
        Iy_2 = Iy.^2;
        [xx,yy] = meshgrid(1:sz(2),1:sz(1));
        u = [0;0];
        while dif > tolF && iter<max_iter && delta> tolx
            % only evaluate valid
            ind = find(xx+u(1)>=xx(1)&xx+u(1)<=xx(end)&yy+u(2)>=yy(1)&yy+u(2)<=yy(end));
            I2 = interp2(f2,xx+u(1),yy+u(2));
            It = I2(ind)-f1(ind);
            delta = dif;
            dif = mean(abs(It(:)));
            delta = abs(dif-delta);
            V = [sum(Ix_2(ind)),Ix(ind)'*Iy(ind);Ix(ind)'*Iy(ind),sum(Iy_2(ind))];
            du = -V\[sum(Ix(ind).*It);sum(Iy(ind).*It)];
            u = u+du;
            fprintf('flow: (%.2f,%.2f), err: %f, change: %f\n',u(1),u(2),dif,delta)
            %keyboard
            iter= iter+1;
        end
end
