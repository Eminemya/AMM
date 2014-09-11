param_init
aa = {'1500' '3000' '4500' '6000' '7500' '9000'};
for aid =1:numel(aa)
f1=str2num(aa{aid});fl=f1*0.99;fh=f1*1.01;fs=50000;
a=VideoReader(['data/' aa{aid} 'Hz_50000fps_l3.avi']);
tmp_vr = a.read();
sz = size(tmp_vr);
% spatial mask
mask=U_mask(tmp_vr(:,:,1,1),70,5);
% narrow band
%mask2 = zeros(sz(1:2));[yy xx]=meshgrid(1:sz(1),1:sz(2));mask2(yy-1.65*xx<-33&yy-1.65*xx>-37)=1;%imagesc(mask2.*double(tmp_vr(:,:,1)))
% wide band
mask2 = zeros(sz(1:2));[yy xx]=meshgrid(1:sz(1),1:sz(2));mask2(yy-1.65*xx<-27&yy-1.65*xx>-40)=1;mask2(:,[1:7 85:96])=0;%tmp=double(tmp_vr(:,:,1:3));tmp(:,:,1)=tmp(:,:,1).*mask2;imagesc(uint8(tmp))
rr0={[30 40 10 25],[40 50 25 45],[50 60 50 65],[60 70 70 85],[48 52 1 96],[1 96 1 96]};
%{
% old phase extraction
a=T_getPhase(tmp_vr,4);
p1 = bsxfun(@times,a{1},mask);
temporalFilter = @FIRWindowBP;
p11 = temporalFilter(p1, fl/fs,fh/fs); 
%}
i=5;
pps=cell(8,8);
mag=zeros(8,8,2);
for sc=0%0:7
    for or=1%0:7
%p11=T_getPhase2(tmp_vr,'halfOctave',sc,or,fs,fl,fh);
p11=T_getPhase2(tmp_vr,'halfOctave',sc,or,fs,fl,fh,-30);
sz_p = size(p11);
p11=bsxfun(@times,p11,imresize(mask2,sz_p(1:2),'bilinear')>0);
p11 = reshape(p11,[prod(sz(1:2)) sz(4)]);
pp = zeros(size(p11));
gid = find(sum(p11~=0,2)>0);
num_f = floor(fs/f1*0.8);
for i=1:numel(gid)
    [a,b1]=findpeaks(double(p11(gid(i),:)),'minpeakdistance',num_f);
    % clf,hold on,plot(p11(gid(i),:)),plot(b,a,'rx')
    [a,b2]=findpeaks(-double(p11(gid(i),:)),'minpeakdistance',num_f);
    pp(gid(i),:) = interp1([b1 b2],[ones(1,numel(b1)) -ones(1,numel(b2))],1:sz(end));
end
pp=reshape(pp,sz([1:2 4]));
save(['pp' aa{aid}],'pp')
%U_ims2gif(uint8(pp*128+128),['pp' aa{aid} '.gif'],0,1/30)
    %{
    rr0{6}([2 4])=sz_p(1:2);
    tmp0 = reshape(p11(rr0{i}(1):rr0{i}(2),rr0{i}(3):rr0{i}(4),:),[],sz(end));
    tmp0(sum(tmp0>0,2)==0,:)=[];
    keyboard
    pps{sc+1,or+1}=tmp0;
    mag(sc+1,or+1,1)=max(max(tmp0));
    mag(sc+1,or+1,2)=max(max(abs(tmp0)));
    %}
    %mag(sc+1,or+1,1)=max(mean(tmp0));
    %mag(sc+1,or+1,2)=max(mean(abs(tmp0)));
    %{
    tmp0(max(tmp0,[],2)<0.2,:)=[];
    subplot(121),plot(mean(tmp0));
    subplot(122),plot(mean(abs(tmp0)));
    saveas(gcf,['phase_' aa{aid} '_sc' num2str(sc) '_or' num2str(or) '.png'])
    %}
end
end
%{
    clf,
    plot(mag(:,:,1))
    clf,plot(mean(tmp0));
    subplot(122),plot(mean(abs(tmp0)));
    saveas(gcf,['phase_' aa{aid} '_sc' num2str(sc) '_or' num2str(or) '.png'])
keyboard
%}
end
