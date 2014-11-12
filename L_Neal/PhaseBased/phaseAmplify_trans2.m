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

function outName = phaseAmplify_trans2(mid,fr,sr,region,vidFile, magPhase , fl, fh,fs, outDir, varargin)

    %% Read Video
    if strcmp(vidFile(end-2:end),'mat')
        load(vidFile)
        vid = tmp_vr;
        clear tmp_vr
        writeTag = vidFile(find(vidFile=='/',1,'last'):find(vidFile=='.',1,'last'));
        FrameRate = fr;
    else
        vr = VideoReader(vidFile);
        [~, writeTag, ~] = fileparts(vidFile);
        FrameRate = vr.FrameRate;    
        FrameRate = 10;
        vid = vr.read();
        if size(vid,3)==1;vid=cat(3,vid,vid,vid);end
        %keyboard
    end
    
    [h, w, nC, nF] = size(vid);
    %% Parse Input
    p = inputParser();

    defaultAttenuateOtherFrequencies = false; %If true, use reference frame phases
    pyrTypes = {'octave', 'octave_4', 'halfOctave', 'halfOctave_2','halfOctave_3','halfOctave_4', 'smoothHalfOctave', 'quarterOctave'}; 
    checkPyrType = @(x) find(ismember(x, pyrTypes));
    defaultPyrType = 'octave';
    defaultSigma = 0;
    defaultTemporalFilter = @FIRWindowBP;
    defaultScale = 1;
    defaultFrames = [1, nF];
    
    addOptional(p, 'attenuateOtherFreq', defaultAttenuateOtherFrequencies, @islogical);
    addOptional(p, 'pyrType', defaultPyrType, checkPyrType);
    addOptional(p,'sigma', defaultSigma, @isnumeric);   
    addOptional(p, 'temporalFilter', defaultTemporalFilter);
    addOptional(p, 'scaleVideo', defaultScale);
    addOptional(p, 'useFrames', defaultFrames);
    
    addOptional(p, 'redo', 0);
    addOptional(p, 'filt_level', -1);
    
    parse(p, varargin{:});

    refFrame = 1;
    attenuateOtherFreq = p.Results.attenuateOtherFreq;
    pyrType            = p.Results.pyrType;
    sigma              = p.Results.sigma;
    temporalFilter     = p.Results.temporalFilter;
    scaleVideo         = p.Results.scaleVideo;
    frames             = p.Results.useFrames;
    redo               = p.Results.redo;
    filt_level               = p.Results.filt_level;
    if isinf(frames(end));frames(end)=nF;end

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
            else
                tmp=tmp(-sr+(0:1));
            end
            %keyboard
            filters = getFilters([h w], tmp, 8,'twidth', 0.75);
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
            else
                tmp=tmp(end+(100+sr):end);
            end
            filters = getFilters([h w], tmp, 2);
            % rotate the filter
            %V_filter(filters(2:end-1),[2 8]);
            for i=2:numel(filters)-1
                filters{i}=imrotate(filters{i},filt_level(1),'bilinear','crop');
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

    outName = sprintf('%s-%s-band%0.2f-%0.2f-sr%d-alpha%d-mp%d-sigma%d-scale%0.2f-frames%d-%d-%s-%d-%d-%d-%d.avi', writeTag, func2str(temporalFilter), fl, fh,fs, mean(magPhase(:)), attenuateOtherFreq, sigma, scaleVideo, frames(1), frames(2), repString,mid,nF,sr(1)+(1+prod(filt_level))*1000,region(1));
    if redo || ~exist(outName,'file')
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
    clear vid;
    rr = [];rr2=0;
    if ~isempty(region)
        rr = zeros([h,w]);rr(region(1):region(2),region(3):region(4))=1;
    end
    for level = 2:numLevels-1
        %% Compute phases of level
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
        delta = temporalFilter(delta, fl/fs,fh/fs); 


        %% Apply magnification
        
        fprintf('Applying magnification\n');
        if ~isempty(rr) 
            rr2 = imresize(rr,[size(pyrRef,1), size(pyrRef,2)],'nearest'); 
        end 
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
                pp =0; 
                if nnz(rr2) 
                    %if nnz(rr2)==0;keyboard;end 
                    pp = median(phaseOfFrame(rr2~=0)); 
                    phaseOfFrame = phaseOfFrame - pp; 
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
                if nnz(rr2) 
                    phaseOfFrame = phaseOfFrame + pp; 
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

    clear vidFFT;

    if strcmp(vidFile(end-2:end),'mat')
        load(vidFile)
        %vid = tmp_vr(:,:,:,1:100);
        %vid = tmp_vr(:,:,:,1:100);
        vid = tmp_vr;
        clear tmp_vr
    else
        vr = VideoReader(vidFile);
        vid = vr.read();
        if size(vid,3)==1;vid=cat(3,vid,vid,vid);end
    end
    vid = vid(:,:,:,frames(1):frames(2));

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

    writeVideo(res, FrameRate, fullfile(outDir, outName));   
end
