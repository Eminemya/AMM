clear; 
close all;

particleList = synthSeedParticles('xDensity', 15, 'yDensity', 15);
accelerationField = synthCreateSoundWave(0,0,10);

timeStep = 0.01;
for k = 1:1000
    out(:,:,1,k) = renderParticleList(particleList);
    particleList = synthAdvectParticles(particleList, @(x) accelerationField(x(1),x(2),k*timeStep), timeStep);
    k
end