function figsize(varargin)
% Set a figure to a specific size
%
% When saving a figure as a PDF, it is necessary to set the
% figure size appropriately. This function sets the "paper size"
% sufficient that the figure is saved with a tight bounding box.
% It will also set the figure size on screen correspondingly.
%
% figuresize(width,height) - sets the figure size in centimeters
% figuresize(width,height,units) - sets the figure size in <units>
%
% <units> can be any of the standard Matlab lengths.

p = inputParser;
p.addRequired('width', @(x) isnumeric(x) && all(size(x)==1) );
p.addRequired('height',@(x) isnumeric(x) && all(size(x)==1) );
p.addOptional('units','pixels',...
  @(x) any(strcmpi(x,{'normalized','centimeters','inches','points','pixels'})) );

p.parse(varargin{:});
width = p.Results.width;
height = p.Results.height;
units = p.Results.units;

p = 0.01;

set(gcf,'Units',units);
screenpos = get(gcf,'Position');

set(gcf,...
  'Position',[screenpos(1:2) width height]);
%   'PaperUnits',units,...
%   'PaperPosition',[p*width p*height width height],...
%   'PaperSize',[width*(1+2*p) height*(1+2*p)]);
