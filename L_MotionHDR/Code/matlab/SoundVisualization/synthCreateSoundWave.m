function func = synthCreateSoundWave(x0, y0, v)
    r = @(x,y,t) sqrt((x-x0).^2+(y-y0).^2);
    func = @(x,y,t) 1*sin(2*pi*(r(x,y,t)-v*t)*5)./(eps+r(x,y,t))*[(x-x0), (y-y0)];
end

