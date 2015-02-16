%%
do_step1=0;do_step2=1;
%do_step1=1;do_step2=0;

%{
% meta
DD0='data/data_1114/';
states= {'s','t'};
f0= [50 100];
fs = [500 500];
nn_func = @(sid,stid) sprintf('%dHz_500fps_%s',f0(sid),states{stid});
frans={{101:161,101:161},{718:868,751:1001}};
max_flo = 0.15;
max_arr = 50;
ballSpacing = 50;
alpha = 0.05;
ratio = 0.5;
minWidth = 100;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
ran_func = @(sz) {10:sz(1),20:sz(2)};
sn_fs = 100;
%}

% tri-lattice
DD0='data/data_0926/';
sn_fs = 1000;
f0= [1100 2100 3000 4300];
fs= [4700 6400 11019 11019];
nn_func = @(sid,stid) sprintf('%dHz_%dfps_l',f0(sid),fs(sid));
frans={{101:161,101:161,101:161,101:161}};
max_flo = 0.001;
max_arr = 50;
ballSpacing = 50;
ran_func = @(sz) {1:sz(1),1:sz(2)};
alpha = 0.05;
ratio = 0.5;
minWidth = 100;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
rmpath(genpath('/Users/Stephen/Code/amm/lib/MotionHDR/Code/matlab/MatlabTools/thirdparty/OpticalFlowCe/mex'))
addpath(genpath([DLIB 'Low/Flow/CeOF/']))

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
%{
% change the flow a bit
frans={{101:161,101:161},{718:868,751:1001}};
for stid = 1:2
for sid = 1:2
    nn = sprintf('%dHz_500fps_%s',f0(sid),states{stid});
    fprintf('1. Read data: %s\n',nn)
    load([nn '_f.mat'])
    size(tmp_f)
    DD = [DD0 nn '/'];
    fns = dir([DD '/*.tif']);
    fran = {fns(frans{stid}{sid}).name};
        tmp1 = im2single(imread(fullfile(DD, fran{end-1})));
        tmp2 = im2single(imread(fullfile(DD, fran{end})));
        [a,b] = Coarse2FineTwoFrames(tmp1,tmp2,para);
        tmp_f = cat(4,tmp_f,cat(3,a,b));
save([nn '_f.mat'],'tmp_f')
end
end
%}

%{
imagesc([0 max_flo]);colorbar;saveas(gcf,'cb.png')
%}

for stid = 1
    for sid = 1:4
        nn = nn_func(sid,stid);
        fprintf('1. Read data: %s\n',nn)
        
        if(exist([nn '_f.mat'],'file'))
            load([nn '_f.mat'])
            sz = size(tmp_f);
            num_f = sz(4);
            ran = ran_func(sz);
        else
            DD = [DD0 nn '/'];
            fns = dir([DD '/*.tif']);
            tmp = im2single(imread(fullfile(DD, fns(1).name)));
            sz = size(tmp);
            ran = ran_func(sz);
            tmp_v = zeros([sz(1:2) num_f]);
            fran = {fns(frans{stid}{sid}).name};
            num_f = numel(fran);
            if(numel(sz)==3)
                parfor i =1:num_f
                    tmp_v(:,:,i) = im2double(rgb2gray(imread(fullfile(DD,fran{i}))));
                end
            else
                parfor i =1:num_f
                    tmp_v(:,:,i) = im2double(imread(fullfile(DD,fran{i})));
                end
            end
            
            %{
    nn= 'data/meta_0721/50Hz_1000fps_ex_990us_l.avi';
    vid = VideoReader(nn);
    tmp_v = squeeze(im2double(vid.read(100+[1 num_f])));
            %}
            fprintf('2. Estimate Motion: %s\n',nn)
            
            tmp_f = zeros([sz(1:2) 2 num_f-1]);
            tmp_v2 = tmp_v(:,:,2:end);
            parfor i =1:num_f-1
                [a,b] = Coarse2FineTwoFrames( ...
                    tmp_v(:,:,i),tmp_v2(:,:,i),para);
                tmp_f(:,:,:,i) = cat(3,a,b);
            end
            % imagesc(flowToColor(tmp_f(:,:,:,1),1))
            mask = (tmp_v(:,:,1)>0.005);
            tmp_f = bsxfun(@times,tmp_f,double(mask));
            save([nn '_f.mat'],'tmp_f')            
        end
        
        if do_step1
            fprintf('3. Display Motion: %s\n',nn)
            v_flo = zeros([sz(1:2),3,sz(end)-1]);
            %max_flo = max(reshape(sqrt(sum(tmp_f(:,:,1:2,:).^2,3)),1,[]))/2.2;
            %max_flo = max(reshape(sqrt(sum(tmp_f(:,:,1:2,:).^2,3)),1,[]))/3;
            %{
    parfor i= 1:num_f-1
           v_flo(:,:,:,i) = flowToColor(tmp_f(:,:,1:2,i),max_flo);
    end
    U_ims2gif(uint8(v_flo),sprintf('lk_%d_%d.gif',1,30),0,0.03)
            %}
            
            set(0,'DefaultFigureWindowStyle','normal')
            
            for i= 1:num_f-1
                clf
                %axis([0 sz(2) 0 sz(1)])
                axis([0 sz(2) 0 sz(1)])
                %imagesc(sqrt(sum(flo(:,:,1:2,i).^2,3))/max_flo),caxis([0 max_flo])
                tmp_im = ind2rgb(gray2ind(uint8(255*sqrt(sum(tmp_f(:,:,1:2,i).^2,3))/max_flo),255),jet(255));
                imshow(tmp_im(ran{1},ran{2},:))
                hold on,%axis off,axis tight,axis equal
                curr_f=max_arr*tmp_f(end:-1:1,:,1:2,i)/max_flo;
                h = V_quiver(curr_f,ballSpacing);
                a=getframe;
                v_flo(:,:,:,i) = imresize(a.cdata,sz(1:2),'nearest');
            end
            U_ims2gif(uint8(v_flo),[nn '_vf.gif'],0,snfs/fs(sid));
            %{
    tmp2 =tmp(ran{1},ran{2});
    tmp2(tmp2)
    imwrite(tmp2,'mask.png')
            %}
        end
        if do_step2
            fprintf('4. Temporal FFT: %s\n',nn)
            nq_f = floor(num_f/2);
            tmp_fE = squeeze(sqrt(sum(tmp_f(:,:,1:2,:).^2,3)));
            delta_fft = fft(bsxfun(@minus,tmp_fE,mean(tmp_fE,3)),[],3);
            E_fft = squeeze(mean(mean(abs(delta_fft(ran{1},ran{2},:)),1),2));
            E_fft = E_fft(1:nq_f);
            [a,b]=max(double(E_fft));
            b= round(f0(sid)*nq_f/fs(sid))
            tmpE = abs(delta_fft(ran{1},ran{2},b));
            tmpP = angle(delta_fft(ran{1},ran{2},b));
            imwrite(U_g2rw(tmpE,2.5,0),[nn 'tE.png'])
            imwrite(U_g2rw(tmpP,2*pi,-pi),[nn 'tP.png'])
            % imagesc([-pi pi]);colorbar;saveas(gca,'cb_p.png')
            % imagesc([0 2.5]);colorbar;saveas(gcf,'cb_E.png')
        end
    end
end