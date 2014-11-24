resultsDir = 'Results';
mkdir(resultsDir);
scaleAndClipLargeVideos = true; % With this enabled, approximately 4GB of memory is used

% Uncomment to use octave bandwidth pyramid: speeds up processing,
% but will produce slightly different results
%defaultPyrType = 'octave'; 

% Uncomment to process full video sequences (uses about 16GB of memory)
%scaleAndClipLargeVideos = false;

sigma = 2;
attenuateOtherFrequencies = true;

if ~exist('alpha','var');alpha=100;end
if ~exist('mid','var');mid=0;end
if ~exist('sr','var');sr=1;end
if ~exist('fr','var');fr=30;end
if ~exist('domask','var');domask=0;end
if ~exist('pyrType','var');pyrType = 'halfOctave'; end
if ~exist('filt_level','var');filt_level = -1; end
if ~exist('tempF','var');tempF = 0; end

inFile = fullfile(DIR_DATA,nn);nF=tt;samplingRate = f0; % Hz
switch fid
case 0
    % no temporal filter
    loCutoff = 0;
    hiCutoff = 0;
case 1
    loCutoff = ceil(f1*.99);
    hiCutoff = ceil(f1*1.01);
case 2
    loCutoff = (f1-1)/(0.5*f0);
    hiCutoff = (f1+1)/(0.5*f0);
case 3
    loCutoff = ceil(f1*.9);
    hiCutoff = ceil(f1*1.1);
case 4
    % remove low/high freq noise
    loCutoff = ceil(f0*0.1);
    hiCutoff = ceil(f0*0.4);
case 5
    % remove low/high freq noise
    loCutoff = f1-2;
    hiCutoff = f1+2;
end
if domask>0 
    disp('do mask')
    if domask==1 && numel(whos(matfile(inFile),'mask'))
        load(inFile,'mask')
    end
    alpha = alpha*ones(size(mask));
    alpha(mask==0)= 1;
end
%keyboard
PA(mid,fr,sr,inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'attenuateOtherFreq', attenuateOtherFrequencies,'pyrType', pyrType, 'scaleVideo', 1, 'useFrames', nF,'filt_level',filt_level,'tempF',tempF);
%PA(mid,fr,sr,region,inFile, alpha, loCutoff, hiCutoff, samplingRate, resultsDir,'sigma', sigma,'attenuateOtherFreq', attenuateOtherFrequencies,'pyrType', pyrType, 'scaleVideo', 1, 'useFrames', nF,'filt_level',filt_level);

%writeVideo(tmp_vr, 5, 'sturcture2.avi');   
%{
% side by side comparison
param_init
num=1000;
nf= 32;
sr =30;
v1 = VideoReader(['/data/vision/billf/auto-mm/www/cases/struct_0501/' num2str(num) 'Hz.avi']);
v1 = v1.read();
v1 = v1(:,:,:,1:nf);
sz =size(v1);
v11 = cat(4,reshape(repmat(reshape(v1(:,:,:,1:nf-1),[],nf-1),sr,1),[sz(1:3) (nf-1)*sr]),v1(:,:,:,nf));

v2 = VideoReader(['/data/vision/billf/auto-mm/www/cases/struct_0501/' num2str(num) 'Hz_30.avi']);
v2 = v2.read();

writeVideo(im2uint8(cat(2,v11,v2)), 30, [num2str(num) 'Hz_comp.avi']);

%}
