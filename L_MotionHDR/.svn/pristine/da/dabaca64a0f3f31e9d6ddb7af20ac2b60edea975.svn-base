function [siz] = vidgrid(vids,captions,outFile,gridSize,scale)
% Input:
%   vids - input videos/image sequences. Can be either a MyVideoReader
%   object, or path to video file or image sequence.
% TODO:
%  - enable contraining only the height or width of the grid

if nargin<2 | isempty(captions)
    for i=1:length(vids)
        captions{i}=[];
    end
end
if nargin<4 | isempty(gridSize)
    gridSize = [1,length(vids)];
end
if nargin<5 | isempty(scale)
    scale = 1; 
end

HMARGIN = 5; % width of margins (pixels)
VMARGIN = 2;
ROWS = gridSize(1); COLS = gridSize(2);

if ROWS*COLS < length(vids)
    error('not enough rows/columns');
end

if ~isempty(captions) & length(captions)~=length(vids)
    error('text not given for all results');
end

% read content. Assumes corresponding order in all directories!
for i=1:length(vids)
    if isa(vids{i},'MyVideoReader')
        D(i) = vids{i};
    else % assuming string
        D(i) = MyVideoReader(vids{i});
    end
end
n = max([D.length]); % output video will be as long as the longest sequence

% adjust to first frame of first sequence.
[H,W]=D(1).dimensions;

% prepare text
txtHeight = 0;
for i=1:length(vids)
    if ~isempty(captions{i})
        
        captions{i} = txt2im(captions{i},[],[],W*scale,'FontSize',14','FontName','Times New Roman'); % TODO: export settings
        txtHeight = size(captions{i},1);
    end
end
    
% calculate dimensions, and pad to the nearest multiple of 8 (always a
% good idea to prevent some encoding problems)
frameHeight = H*scale*ROWS+(txtHeight+VMARGIN)*ROWS;
frameWidth = W*scale*COLS+HMARGIN*(COLS-1);
dh = 8-mod(frameHeight,8); dw = 8-mod(frameWidth,8);
di = floor(dh/2); dj= floor(dw/2);
frameHeight = frameHeight + dh;
frameWidth = frameWidth + dw;

im = zeros(frameHeight, frameWidth, 3, 'uint8');

disp('vidgrid: Rendering...');
vidOut = MyVideoWriter(outFile,[],D(1).frameRate);
progmeter(0,n);
for t=1:n
    
    progmeter(t,n);
    
    row = 1; col = 1;
    for i=1:length(D)

        % read image and embed text
        if t <= D(i).length
            im_i = D(i).frame(t);
            if size(im_i,3)==1
                im_i = repmat(im_i,[1,1,3]);
            end
            if ~all(size(im_i)==[H,W,3])
                im_i = imresize(im_i,[H,W]);
            end
        %         if ~isempty(captions) & ~isempty(captions{i})
        %             im_i = embedtext(im_i, captions{i});
        %         end
        else
            im_i = zeros(D(i).height,D(i).width,D(i).nChannels);
        end
        
        if scale~=1
            im_i = imscale(im_i,scale);
        end

        if row==1 i1=di+1; else i1=fix(di+(row-1)*H*scale+1+(txtHeight+VMARGIN)*(row-1)); end
        if col==1 j1=dj+1; else j1=fix(dj+(col-1)*W*scale+1+HMARGIN*(col-1)); end
        im(i1:fix(i1+H*scale-1),j1:fix(j1+W*scale-1),:) = im2uint8(im_i);
        
        if ~isempty(captions{i})
            im(fix(i1+H*scale:i1+H*scale+txtHeight-1),j1:fix(j1+W*scale-1),:) = captions{i};
        end
        
        if col==COLS
            row = row+1;
            col = 1;
        else
            col = col+1;
        end
    end
    
%     imwrite(im,sprintf('%s/%04d.png',tmpDir,t)); % store uncompressed
    vidOut.append(im);
    if t==1, siz = [size(im,1) size(im,2)]; end
end

for i=1:length(vids)
    D(i).close;
end

% seq2movie(tmpDir,outFile,format);
% remove temporary images
% delete(sprintf('%s\\*.png',tmpDir));
% rmdir(tmpDir);

