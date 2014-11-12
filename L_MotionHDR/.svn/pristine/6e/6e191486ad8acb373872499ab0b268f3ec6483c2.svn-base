function particleList = synthAdvectParticles( particleList, accelerationField, timeStep )
    for k = 1:numel(particleList)
       temp = particleList{k}.advect(accelerationField, timeStep);
       particleList{k} = temp;
    end

end

