function [ dy ] = soundStandingWave( t, y, c, x0, y0, omega, ~, B)    
    r = sqrt((y(1)-x0)^2+(y(2)-y0)^2);
    A = r - c * t;
    dy(1) =  B*cos(2*pi/omega *A).*(y(1)-x0)./(eps+r);
    dy(2) =  B*cos(2*pi/omega *A).*(y(2)-y0)./(eps+r);    
    dy = dy';
    
end

