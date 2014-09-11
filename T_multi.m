nns = {'Gau','rect','tri'};
for nid = 1:3
nn = ['0727/' nns{nid} '_wn_10000Hz_32000fps_l1.avi'];

a=VideoReader(nn);a=a.read();
tmp_vr=cat(3,a,a,a);
fl=0;fh=0;fs=-1;
for sc=0:8;
for or=0:1;
addpath(genpath('Neal'))
phase = T_getPhase2(tmp_vr,'halfOctave_4',sc,or,fs,fl,fh,-60);
sz_p = size(phase); 
im = imresize(tmp_vr(:,:,1),sz_p(1:2),'nearest');
ind = find(im>50);
B_ana
L = get(gca,'XLim');
set(gca,'XTick',linspace(L(1),L(2),5))
set(gca,'XTickLabel',arrayfun(@(x) num2str(x),0:4000:16000,'UniformOutput',false))
%set(gca,'XTickLabel',arrayfun(@(x) num2str(floor(x)),(0:200:tcen)/tcen*16000,'UniformOutput',false))
saveas(gca,[nns{nid} '_' num2str(sc) '_' num2str(or) '.png'])
end;end

end
