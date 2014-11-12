clear;
rootDir = fullfile(getRootDir(), 'Donglai');


files = {'soccer_f63542-64658.avi',  'TrimmedAntenna9359.mp4'}';
for vNum = 1:numel(files)
    [~, vidName, ~]= fileparts(files{vNum});    
    outDir = fullfile(rootDir, vidName);
    mkdir(outDir);
    vidFile = fullfile(rootDir, [vidName '.avi'])


    vr = VideoReader(vidFile);
    vid = rgb2y(im2single(vr.read()));


    [buildPyr, ~] = octave4PyrFunctions(size(vid,1), size(vid,2), 2);

    for k = 1:size(vid,4)
       [pyrs(:,k),pind] = buildPyr(vid(:,:,1,k));
       pyrVid = pyrVid2CellVid(pyrs, pind);
    end


    %% separate into amplitude and phase
    angles = [0 90 90 45];
    phaseScalars = [1.72 0.86 0.44 0.22 0.11];

    
    
    for sc = 1:5
        for or = 1:2    
            bandIDX = 1+or+(sc-1)*2;
            eval(sprintf('amp_scale%d_orient%d =  squeeze(abs(pyrVid{bandIDX}));', sc, angles(or)));
            temp = angle(pyrVid{bandIDX});
            temp = mod(pi+bsxfun(@minus, temp, temp(:,:,:,1)),2*pi)-pi;
            temp = squeeze(temp./phaseScalars(sc));
            eval(sprintf('phase_scale%d_orient%d =  temp;', sc, angles(or)));

        end
    end



    clear vr
    clear sc
    clear or
    clear bandIDX
    clear temp
    clear pyrVid
    clear pyrs
    clear pind
    clear buildPyr
    clear k
    clear angles

    %% Save
    save(fullfile(outDir, 'amplitudes_phases.mat'));
end