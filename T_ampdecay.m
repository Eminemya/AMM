addpath(genpath('Neal'))

nn='0727/100Hz_1000fps_ex_990us_l.avi';
a=VideoReader(nn);a=a.read();
tmp_vr=cat(3,a,a,a);
fl=99;fh=101;fs=1000;
sc=-11;
or=0;
phase = T_getPhase2(tmp_vr,'halfOctave_4',sc,or,fs,fl,fh,-45);
sz_p = size(phase); 
% scale decompose I: whole pyramide + take a few filters
%im = imresize(tmp_vr(:,:,1),sz_p(1:2),'nearest');
% scale decompose II: take a few filters
im = tmp_vr(:,floor((size(tmp_vr,2)-sz_p(2))/2)+(1:sz_p(2)),1));

inds = [];


ind = find(im>50);

im_ind = reshape(1:numel(im),size(im));
ind = reshape(im_ind(15:20,125:128));

ind2 = bsxfun(@minus,ind,19*size())
m1 = im>100;
mask = []; 
