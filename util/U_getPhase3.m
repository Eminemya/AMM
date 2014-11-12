function [delta,amp ]=T_getPhase3(vid,pyrType,sc,or,filt_level)
if(~exist('filt_level','var'));filt_level=0;end
refFrame=1;
temporalFilter = @FIRWindowBP;

[h, w, nC, nF] = size(vid);
ht = maxSCFpyrHt(zeros(h,w));
    switch pyrType
        case 'octave'
            filters = getFilters([h w], 2.^[0:-1:-ht], 4);
            %numel(filters)
            %keyboard
            level = 2+sc*4+or;
            repString = 'octave';
            fprintf('Using octave bandwidth pyramid\n');        
        case 'halfOctave'            
            tmp = 2.^[0:-0.5:-ht];
            level = 2+sc*8+or;
            %keyboard
            filters = getFilters([h w], tmp, 8,'twidth', 0.75);
            %filters = getFilters([h w], 2.^[0:-0.5:-ht], 8,'twidth', 0.75);
            repString = 'halfOctave';
            fprintf('Using half octave bandwidth pyramid\n'); 
        case 'halfOctave_2'
            tmp = 2.^[0:-0.5:-ht];
            level = 2+sc*6+or;
            %keyboard
            filters = getFilters([h w], tmp, 6,'twidth', 0.75);
            mid_b=6;
            repString = 'halfOctave_2';
            fprintf('Using half octave bandwidth pyramid\n'); 
         case 'threelevel'
            level = 2+or;
            filters = getFilters([h w], 2.^[0:-1:-1], 2);
            for i=2:numel(filters)-1
                filters{i}=imrotate(filters{i},filt_level(1),'bilinear','crop');
            end
          case {'octave_5','halfOctave_5'}
             if pyrType(1)=='o'
                tmp = 2.^[0:-1:-ht];
             else
                tmp = 2.^[0:-0.5:-ht];
            end 
            % keyboard
            if sc>0
                tmp=tmp([1 sc]);
            end
            level = 2+or;
            filters = getFilters([h w], tmp, 2);
            % rotate the filter
            %V_filter(filters(2:end-1),[2 8]);
            if filt_level(1)~=0
                for i=2:numel(filters)-1
                    filters{i}=imrotate(filters{i},filt_level(1),'bilinear','crop');
                end
            end
            mid_b=2;

            %keyboard
         case {'octave_4','halfOctave_4'}
             if pyrType(1)=='o'
                tmp = 2.^[0:-1:-ht];
             else
                tmp = 2.^[0:-0.5:-ht];
            end
    
            level = 2+sc*2+or;
            %keyboard
            filters = getFilters([h w], tmp, 2);
            % rotate the filter
            %keyboard
            %V_filter(filters(2:end-1),[2 8]);
            for i=2:numel(filters)-1
                filters{i}=imrotate(filters{i},filt_level(1),'bilinear','crop');
            end
            %keyboard
            %V_filter(filters(2:end-1),[2 (numel(filters)-2)/2]);
            %saveas(gca,'filter.jpg');close
            mid_b=2;
        case 'smoothHalfOctave'
            filters = getFiltersSmoothWindow([h w], 8, 'filtersPerOctave', 2);           
            repString = 'smoothHalfOctave';
            fprintf('Using half octave pyramid with smooth window.\n');
        case 'quarterOctave'
            filters = getFiltersSmoothWindow([h w], 8, 'filtersPerOctave', 4);
            repString = 'quarterOctave';
            fprintf('Using quarter octave pyramid.\n');
        otherwise 
            tmp = 2.^[0:-0.5:-ht];tmp=tmp(1:pyrType);
            filters = getFilters([h w], tmp, 8,'twidth', 0.75);
            error('Invalid Filter Types');
    end
    [croppedFilters, filtIDX] = getFilterIDX(filters);
    buildLevel = @(im_dft, k) ifft2(ifftshift(croppedFilters{k}.* ...
        im_dft(filtIDX{k,1}, filtIDX{k,2})));
    reconLevel = @(im_dft, k) 2*(croppedFilters{k}.*fftshift(fft2(im_dft)));
    numLevels = numel(filters);        
    vidFFT = zeros(h,w,nF,'single');
    for k = 1:nF
        originalFrame = rgb2ntsc(im2single(vid(:,:,:,k)));
        %keyboard
        tVid = imresize(originalFrame(:,:,1), [h w]);
        vidFFT(:,:,k) = single(fftshift(fft2(tVid)));
    end
    clear vid;
     pyrRef = buildLevel(vidFFT(:,:,refFrame), level);        
       delta = zeros(size(pyrRef,1), size(pyrRef,2) ,nF,'single');
        amp = zeros(size(pyrRef,1), size(pyrRef,2) ,nF,'single');
        
        for frameIDX = 1:nF
            amp(:,:,frameIDX) = buildLevel(vidFFT(:,:,frameIDX), level);
            delta(:,:,frameIDX) = angle(amp(:,:,frameIDX));
            %keyboard
        end
    amp = abs(amp);
