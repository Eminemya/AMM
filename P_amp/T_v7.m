addpath(genpath('lib/MoStable/'))
addpath(genpath('Neal/'))
nnr = './ultra/';
%nnr = 'data/ultra/';
fns = dir([nnr '*.avi']);
tts{1}={[1 inf],[1 inf],[1 inf],[1 inf],[1 inf],[1 inf]};
PA=@phaseAmplify;

alphas = [50 ];

mid=0;sr=1;do_mask=0;
rrs=[100,450,1,680 240,280,390,440  170,250,50,250];

for f1=[2 4 8 12 15]%[3 6 12 18 23];
for i = 1%1:numel(fns)
    nn = fns(i).name;
    pyrType='halfOctave';filt_level = -1;mids=[0];
    tt= tts{1}{i};
    if ~exist([nnr nn '_l.mat']) 
        tmp_v = VideoReader([nnr nn]);
        tmp_vr = tmp_v.read(tt);
        tmp_vr = squeeze(tmp_vr(rrs(1):rrs(2),rrs(3):rrs(4),1,:));
        if ~exist([nnr nn '.mat']) 
            save([nnr nn],'tmp_vr')
        end
        tmp_vr2= S_trans(tmp_vr,rrs(5:8),rrs(9:12),10);
        %keyboard
        %tmp_vr3= squeeze(tmp_vr2(:,:,1,:));
        %U_ims2gif(cat(1,tmp_vr,tmp_vr3),[aa{aid} 'Hz_' num2str(f0) 'fps' suf{nump} '_l.gif'],[],0.05);

        %U_ims2gif(cat(1,tmp_vr(rrs(5):rrs(6),rrs(7):rrs(8),:),tmp_vr3(rrs(5):rrs(6),rrs(7):rrs(8),:)),[aa{aid} 'Hz_' num2str(f0) 'fps' suf{nump} '_l2.gif'],[],0.05);
        %writeVideo(U_g2r(cat(1,tmp_vr(rrs(5):rrs(6),rrs(7):rrs(8),:),tmp_vr3(rrs(5):rrs(6),rrs(7):rrs(8),:))), 30, [aa{aid} 'Hz_' num2str(f0) 'fps' suf{nump} '_l2.avi']);   
        %imwrite(uint8(cat(1,5*std(single(tmp_vr),[],3),5*std(single(tmp_vr3),[],3))),[nn '_l_std.png']);
        tmp_vr=tmp_vr2;
        nn=[nn '_l.mat']; 
        save([nnr nn],'tmp_vr')
    else
        nn=[nnr nn '_l.mat']; 
    end
     %keyboard
        %{
        sc=0;or=1;fs=0;fl=0;fh=0;rot=0;
        phase=T_getPhase2(tmp_vr,'halfOctave',sc,or,fs,fl,fh,rot);
        ind = find(tmp_vr(:,:,1)>prctile(reshape(tmp_vr(:,:,1),1,[]),80));
        B_ana
        %}
        %keyboard;  
        f0=48;
    for alpha=alphas%[1000 2000]%[100 200 500];
        for fid=2%1
            do_struct_0501_p
        end
    end
end
end


%{
avs=dir('*.avi');
for aid=1:numel(avs)
    if 1
    %if avs(aid).name(14)=='4' && ~exist(['../../www/cases/struct_0701/' avs(aid).name(1:end-3) 'gif'])
        U_avi2gif(['Results/' avs(aid).name],['Results/' avs(aid).name(1:end-3) 'gif'],0.05);
    end
end

%}
%DD='data/struct_0721/';tt=[1,10];
DD='Results/';
avs=dir([DD '*.avi']);
for aid=1:numel(avs)
    if 1
    %if avs(aid).name(14)=='4' && ~exist(['../../www/cases/struct_0701/' avs(aid).name(1:end-3) 'gif'])
        U_avi2gif([DD avs(aid).name],[DD avs(aid).name(1:end-3) 'gif'],0.05);
    end
end

system('./U_mv.sh')
