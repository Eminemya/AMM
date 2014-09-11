param_init
fns = {'0Hz_11019fps_0_dl.mat','3100Hz_11019fps_l_dl.mat','3640Hz_11019fps_l_dl.mat'};
%fns=dir('data/*_dl.mat');fns = {fns.name};

fr=5;
for fff=1:numel(fns)
nn=fns{fff};
%aa=VideoReader(nn);a=aa.read(1);imagesc(a)
PA=@phaseAmplify;
%region=[5 15 58 68];PA=@phaseAmplify_trans2;

alphas=[3000];
aas=[300 3000 0 1000 500];
%fids = [0 4];
%fids = [0 1 3 4]
fids=1;
%tempF = 0;
%tt=[1 60];
tt=[1 inf];

% sinusoidal simulation
%pyrType='octave_4';filt_level = -30;mids=-1;
%pyrType='halfOctave_4';filt_level = -60;mids=[-1];
%pyrType='halfOctave_3';filt_level = -1;mids=0;%[-27:-25];
%pyrType='halfOctave_2';filt_level = -1;mids=[1];%-100;
%pyrType='halfOctave';filt_level = -1;mids=[0];srs = 1;%-215;%-200-(2:15) ;%-7:-1%1%2:2:6%1:2:7

%pyrType='octave_4';filt_level = 0;mids=0;srs=1;
pyrType='octave';filt_level = 0;mids=0;srs=1;

% fps
f0 = str2num(nn(find(nn=='_',1,'first')+1:find(nn=='f',1,'first')-1));
% Hz
f1 = str2num(nn(1:find(nn=='_',1,'first')-3));
%if f1==0;tempF=0;else tempF=1;end
if f1==0;f1=3640;end;

for mid=mids
for sr=srs
for domask=0
    if domask==2
        load(['data/' nn]);mask=squeeze(tmp_vr(:,:,1,:))>50; 
    end
    for alpha=alphas
    for fid=fids
        if ~isempty(aas)
            alpha = aas(fid+1);
        end
        do_struct_0501_p
    end
    end
end
end
end
end
%{
avs=dir('Results/*.avi');
for aid=1:numel(avs)
    if 1
    %if avs(aid).name(14)=='4' && ~exist(['../../www/cases/struct_0701/' avs(aid).name(1:end-3) 'gif'])
        U_avi2gif(['Results/' avs(aid).name],['Results/' avs(aid).name(1:end-3) 'gif'],0.05);
    end
end
%}

