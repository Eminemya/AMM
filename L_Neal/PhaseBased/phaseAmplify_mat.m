% PHASEAMPLIFY(VIDFILE, MAGPHASE, FL, FH, FS, OUTDIR, VARARGIN)
%
% Takes input VIDFILE and motion magnifies the motions that are within a
% passband of FL to FH Hz by MAGPHASE times. FS is the videos sampling rate
% and OUTDIR is the output directory.
%
% Optional arguments:
% attenuateOtherFrequencies (false)
%   - Whether to attenuate frequencies in the stopband
% pyrType                   ('halfOctave')
%   - Spatial representation to use (see paper)
% sigma                     (0)
%   - Amount of spatial smoothing (in px) to apply to phases
% temporalFilter            (FIRWindowBP)
%   - What temporal filter to use
%

function res = phaseAmplify_mat(mid,sr,vid, magPhase , fl, fh,fs, varargin)
%% Parse Input
p = inputParser();

defaultAttenuateOtherFrequencies = false; %If true, use reference frame phases
pyrTypes = {'octave', 'octave_4', 'halfOctave', 'halfOctave_2','halfOctave_3','halfOctave_4', 'smoothHalfOctave', 'quarterOctave'};
checkPyrType = @(x) find(ismember(x, pyrTypes));
defaultPyrType = 'octave';
defaultSigma = 0;
defaultTemporalFilter = @FIRWindowBP;
defaultScale = 1;
defaultFrames = [1, inf];

addOptional(p, 'attenuateOtherFreq', defaultAttenuateOtherFrequencies, @islogical);
addOptional(p, 'pyrType', defaultPyrType, checkPyrType);
addOptional(p,'sigma', defaultSigma, @isnumeric);
addOptional(p, 'temporalFilter', defaultTemporalFilter);
addOptional(p, 'scaleVideo', defaultScale);
addOptional(p, 'useFrames', defaultFrames);

addOptional(p, 'filt_level', -1);


parse(p, varargin{:});

refFrame = 1;
attenuateOtherFreq = p.Results.attenuateOtherFreq;
pyrType            = p.Results.pyrType;
sigma              = p.Results.sigma;
temporalFilter     = p.Results.temporalFilter;
scaleVideo         = p.Results.scaleVideo;
frames             = p.Results.useFrames;
filt_level         = p.Results.filt_level;
if isinf(frames(end));frames(end)=size(vid,4);end

%% Compute spatial filters
vid = vid(:,:,:,frames(1):frames(2));
[h, w, nC, nF] = size(vid);
if (scaleVideo~= 1)
    [h,w] = size(imresize(vid(:,:,1,1), scaleVideo));
end


fprintf('Computing spatial filters\n');
ht = maxSCFpyrHt(zeros(h,w));
mid_b=8;
switch pyrType
    case 'octave'
        filters = getFilters([h w], 2.^[0:-1:-ht], 4);
        fprintf('Using octave bandwidth pyramid\n');
    case 'halfOctave'
        tmp = 2.^[0:-0.5:-ht];
        if sr>0
            tmp=tmp(1:end+1-sr);
        elseif sr>-100
            tmp=tmp(-sr+(0:1));
        elseif sr>-200
            tmp=tmp(end+(100+sr):end);
        elseif sr>-300
            tmp=tmp([1 -200-sr]);
        end
        filters = getFilters([h w], tmp, 8,'twidth', 0.75);
        %V_filter(filters,[2 5]);axis off;axis equal;saveas(gca,[num2str(-sr) '.png'])
        %V_filter(filters(2:end-1),[2 4]);axis off;axis equal;saveas(gca,[num2str(-sr) '.png'])
        %keyboard
        %filters = getFilters([h w], 2.^[0:-0.5:-ht], 8,'twidth', 0.75);
        fprintf('Using half octave bandwidth pyramid\n');
    case 'halfOctave_2'
        tmp = 2.^[0:-0.5:-ht];
        if sr>0
            tmp=tmp(1:end+1-sr);
        else
            tmp=tmp(-sr+(0:1));
        end
        %keyboard
        filters = getFilters([h w], tmp, 6,'twidth', 0.75);
        if filt_level(1)>=0
            filters =filters([1 1+find(ismember(mod(2:numel(filters)-1,mid_b),filt_level)) end]);
        end
        mid_b=6;
        keyboard
        fprintf('Using half octave bandwidth pyramid\n');
    case 'halfOctave_3'
        tmp = 2.^[0:-0.5:-ht];
        if sr>0
            tmp=tmp(1:end+1-sr);
        elseif sr>-100
            tmp=tmp(-sr+(0:1));
        else
            tmp=tmp(end+(100+sr):end);
        end
        %keyboard
        filters = getFilters([h w], tmp, 36,'twidth', 0.75);
        mid_b=36;
        fprintf('Using half octave bandwidth pyramid\n');
    case {'octave_4','halfOctave_4'}
        if pyrType(1)=='o'
            tmp = 2.^[0:-1:-ht];
        else
            tmp = 2.^[0:-0.5:-ht];
        end
        if sr>0
            tmp=tmp(1:end+1-sr);
        elseif sr>-100
            tmp=tmp(-sr+(0:1));
        elseif sr>-200
            tmp=tmp(end+(100+sr):end);
        elseif sr>-300
            tmp=tmp([1 200+sr]);
        end
        filters = getFilters([h w], tmp, 2);
        % rotate the filter
        if filt_level(1)~=0
            for i=2:numel(filters)-1
                filters{i}=imrotate(filters{i},filt_level(1),'bilinear','crop');
            end
        end
        mid_b=2;
    case 'smoothHalfOctave'
        filters = getFiltersSmoothWindow([h w], 8, 'filtersPerOctave', 2);
        fprintf('Using half octave pyramid with smooth window.\n');
    case 'quarterOctave'
        filters = getFiltersSmoothWindow([h w], 8, 'filtersPerOctave', 4);
        fprintf('Using quarter octave pyramid.\n');
    otherwise
        error('Invalid Filter Types');
end
repString = pyrType;

[croppedFilters, filtIDX] = getFilterIDX(filters);

%% Initialization of motion magnified luma component
magnifiedLumaFFT = zeros(h,w,nF,'single');

buildLevel = @(im_dft, k) ifft2(ifftshift(croppedFilters{k}.* ...
    im_dft(filtIDX{k,1}, filtIDX{k,2})));

reconLevel = @(im_dft, k) 2*(croppedFilters{k}.*fftshift(fft2(im_dft)));


%% First compute phase differences from reference frame
numLevels = numel(filters);
fprintf('Moving video to Fourier domain\n');
vidFFT = zeros(h,w,nF,'single');
for k = 1:nF
    originalFrame = rgb2ntsc(im2single(vid(:,:,:,k)));
    tVid = imresize(originalFrame(:,:,1), [h w]);
    vidFFT(:,:,k) = single(fftshift(fft2(tVid)));
end
%% Compute phases of level
for level = 2:numLevels-1
    
    % We assume that the video is mostly static
    pyrRef = buildLevel(vidFFT(:,:,refFrame), level);
    pyrRefPhaseOrig = pyrRef./abs(pyrRef);
    pyrRef = angle(pyrRef);
    
    delta = zeros(size(pyrRef,1), size(pyrRef,2) ,nF,'single');
    fprintf('Processing level %d of %d\n', level, numLevels);
    
    
    for frameIDX = 1:nF
        filterResponse = buildLevel(vidFFT(:,:,frameIDX), level);
        pyrCurrent = angle(filterResponse);
        delta(:,:,frameIDX) = single(mod(pi+pyrCurrent-pyrRef,2*pi)-pi);
    end
    
    
    %% Temporal Filtering
    fprintf('Bandpassing phases\n');
    if fh~=0
        %keyboard
        delta = temporalFilter(delta, fl/fs,fh/fs);
    end
    
    %% Apply magnification
    
    fprintf('Applying magnification\n');
    
    for frameIDX = 1:nF
        originalLevel = buildLevel(vidFFT(:,:,frameIDX),level);
        if (attenuateOtherFreq)
            tempOrig = abs(originalLevel).*pyrRefPhaseOrig;
        else
            tempOrig = originalLevel;
        end
        
        phaseOfFrame = delta(:,:,frameIDX);
        %% Amplitude Weighted Blur
        if (sigma~= 0)
            phaseOfFrame = AmplitudeWeightedBlur(phaseOfFrame, abs(originalLevel)+eps, sigma);
        end
        % orientation selection
        if (mid==0) ...
                ||(mid<0&&mid>=1-mid_b&&mod(level,mid_b)==-mid) ...
                ||(mid==-100&&mod(level,mid_b)==0) ...
                ||(mid_b==36&&mid==1&&ismember(mod(level,mid_b),[25:27])) ...
                ||(mid_b==6&&mid==1&&ismember(mod(level,mid_b),[5 0 1])) ...
                ||(mid_b==8&&mid==1&&ismember(mod(level,mid_b),[6 7 0 1]))
            % mid=0: all
            % mid=1: hori
            % mid=2: verti
            % Increase phase variation
            if numel(magPhase)==1
                phaseOfFrame = magPhase*phaseOfFrame;
            else
                if size(magPhase,3)==1
                    phaseOfFrame = imresize(magPhase,size(phaseOfFrame),'nearest').*phaseOfFrame;
                else
                    phaseOfFrame = imresize(magPhase(:,:,frameIDX),size(phaseOfFrame),'nearest').*phaseOfFrame;
                end
            end
        end
        
        tempTransformOut = exp(1i*phaseOfFrame).*tempOrig;
        curLevelFrame = reconLevel(tempTransformOut, level);
        magnifiedLumaFFT(filtIDX{level,1}, filtIDX{level,2},frameIDX) = curLevelFrame + magnifiedLumaFFT(filtIDX{level,1}, filtIDX{level,2},frameIDX);
    end
end
%% Add unmolested lowpass residual
level = numel(filters);
for frameIDX = 1:nF
    lowpassFrame = vidFFT(filtIDX{level,1},filtIDX{level,2},frameIDX).*croppedFilters{end}.^2;
    magnifiedLumaFFT(filtIDX{level,1},filtIDX{level,2},frameIDX) = magnifiedLumaFFT(filtIDX{level,1},filtIDX{level,2},frameIDX) + lowpassFrame;
end



res = zeros(h,w,nC,nF,'uint8');
outFrame = zeros(h,w,nC);
%keyboard
for k = 1:nF
    originalFrame = rgb2ntsc(im2single(vid(:,:,:,k)));
    originalFrame = imresize(originalFrame, [h, w]);
    outFrame(:,:,2:3) = originalFrame(:,:,2:3);
    magnifiedLuma = real(ifft2(ifftshift(magnifiedLumaFFT(:,:,k))));
    outFrame(:,:,1) = magnifiedLuma;
    %% Put frame in output
    res(:,:,:,k) = im2uint8(ntsc2rgb(outFrame));
end

end
