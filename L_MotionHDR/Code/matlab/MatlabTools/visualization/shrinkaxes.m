function shrinkaxes(scalefactor)
if(nargin<1)
   scalefactor = .9;
end

% Might be several axes in current figure
axInFig = findall(gcf,'type','axes');

for i=1:length(axInFig)-1 % HACK
    g = get(axInFig(i),'Position');
    g(1:2) = g(1:2) + (1-scalefactor)/2*g(3:4);
    g(3:4) = scalefactor*g(3:4);
    set(axInFig(i),'Position',g);
end
