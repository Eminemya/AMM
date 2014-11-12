sigma = 0.5;
f = @(x) 1/(sqrt(2*pi)*sigma)*exp(-x.^2/(2*sigma.^2));
integral(f,-1e3,1e3)

x0 = 10;
r = 3;
g = @(x) double(abs(x-x0)<r);

y = 8;
h = @(x) g(y-x).*f(x);

integral(h,-1e1,1e1)

1/2*(erf((x0+r-y)/(sqrt(2)*sigma))-erf((x0-r-y)/(sqrt(2)*sigma)))
