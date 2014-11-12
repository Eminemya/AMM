function [ dy ] = soundWavePacketGravity( t, y, c, x0, y0, omega, lambda, B, g, v0)    
    r = sqrt((y(1)-x0)^2+(y(2)-y0)^2);
    A = r - c * t;
    
    part1 = exp(-A.^2/(2*lambda.^2));
    part2 = cos(2*pi*omega*A);
    part3 = sin(2*pi*omega*A);
    part4 = part1.*part2.*2*pi/lambda + part3.*part1.*(-A./lambda^2);
    dy(1) =  B*part4.*(y(1)-x0)./(eps+r);
    dy(2) =  B*part4.*(y(2)-y0)./(eps+r)+g*t+v0;
    dy = dy';
    
end
