classdef particle
    %PARTICLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position
        velocity
    end
    
    methods
        function self = particle(varargin)
           if nargin == 0
               self.position = [0 0];
               self.velocity = [0 0];
           elseif nargin==1
               self.position = varargin{1};
               self.velocity = [0 0];
           else
               self.position = varargin{1};
               self.velocity = varargin{2}; 
           end
           
        end
        
        function self = advect(self, accelerationField, timeStep)
            acceleration = accelerationField(self.position);
            self.velocity = self.velocity + acceleration * timeStep;
            self.position = self.position  + self.velocity * timeStep;
        end        
        
        function plot(self, size, color)
           scatter(self.position(1), self.position(2),  size, color, 'fill');
        end
    end            
end

