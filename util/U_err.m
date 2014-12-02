function err = U_err(x1,s1,x2,s2,opt)
if ~exist('opt','var');opt=1;end
switch opt
    case 1
        err = mean((s2-interp1(x1,s1,x2)).^2);
    case 2
        err = mean(abs(s2-interp1(x1,s1,x2)));
    case 3
        tmp = interp1(x1,s1,x2);
        err = mean(abs((s2-tmp)./tmp));
    case 4
        tmp = interp1(x1,s1,x2);
        err = mean(abs(s2-tmp))/max(abs(tmp));
end