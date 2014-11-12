if ~exist('done_init','var')
    param_init
end
%%
fprintf('Pipeline for motion comparison \n');
DD='data/data_1111/';
nn ='50Hz_500fps_a';im_amp =1; % video frame files
DD = [DD nn '/'];
sn =''; % sensor measurement file
f0 = 500;
do_disp = 0;
% output+5.tif for 12 bit images
fns = dir([DD '/*.tif']);
num_f = min(2000,numel(fns));
tmp_im = im_amp*im2single(imread(fullfile(DD,fns(1).name)));
sz = size(tmp_im);


%%
fprintf('1. get cropped region \n');
% {200:330,30:160}
% {190:260,130:160}
%crop ={{},{},{}};
crop ={{200:240,140:160}};

num_crop = numel(crop);
sz_crop = cell(1,num_crop);
mask_crop = cell(1,num_crop);
for i=1:num_crop
    sz_crop{i} = [numel(crop{i}{1}) numel(crop{i}{2})];
    [yy,xx]=meshgrid(1:sz_crop{i}(2),1:sz_crop{i}(1));
    % imagesc(-xx+1*yy<=-18)
    mask_crop{i} = tmp_im(crop{i}{1},crop{i}{2})>0.15 & tmp_im(crop{i}{1},crop{i}{2})<0.4;
    mask_crop{i} = mask_crop{i}&(-xx+1*yy>-18);
end

if do_disp
    %%
    % at most 3 acc
    for i=1:num_crop
        subplot(num_crop,1,i),imagesc(tmp_im(crop{i}{1},crop{i}{2}))
        %{
        subplot(num_crop,1,i),
        imshow(tmp_im(crop{i}{1},crop{i}{2})),hold on
        plot(1:size(xx,2),(1:size(xx,2))*1+18,'r-')
        
        %}
    end
end


%%
fprintf('2. read video \n');
if ~exist([DD nn '_vid.mat'],'file')
    vid1=[];vid2=[];vid3=[];
    for i=1:num_crop
        eval(['vid' num2str(i) ' = zeros([sz_crop{i} 1 num_f],''single'');']);
    end
    parfor i =1:num_f
        tmp = im_amp*im2single(imread(fullfile(DD, fns(i).name)));
        vid1(:,:,1,i) = tmp(crop{1}{1},crop{1}{2});
        if(num_crop>1)
            vid2(:,:,1,i) = tmp(crop{2}{1},crop{2}{2});
            if(num_crop>2)
                vid3(:,:,1,i) = tmp(crop{3}{1},crop{3}{2});
            end
        end
    end
    % filter light
    for i=1:num_crop
        eval(['tmp_vid= repmat(vid' num2str(i) ',[1,1,3,1]);']);
        tmp_vid = U_remove120(tmp_vid,57,63,f0);
        tmp_vid = U_remove120(tmp_vid,117,123,f0);
        tmp_vid = U_remove120(tmp_vid,237,243,f0);
        eval(['vid' num2str(i) ' = squeeze(tmp_vid(:,:,1,:));']);
    end
    vid ={vid1,vid2,vid3};
    save([DD(1:end-1) '_vid.mat'],'vid')
else
    load([DD(1:end-1) '_vid.mat'],'vid')
end

%%
fprintf('3. motion from video \n');
if ~exist([DD nn '_vid_f.mat'],'file')
    flow_l = cell(1,num_crop);
    for i=1:num_crop
        fprintf('crop: %d\n',i)
        tmp_flow = zeros([sz_crop{i} 2 num_f-1],'single');
        psz=3;
        vid2 = vid{i};
        vid2_tmp= vid2(:,:,2:end);
        parfor j = 1:num_f-1
            tmp_flow(:,:,:,j) = T_lk_p3(vid2(:,:,j), vid2_tmp(:,:,j),psz);
        end
        flow_l{i} = tmp_flow;
    end
    save([DD(1:end-1) '_vid_f.mat'],'flow_l')
else
    load([DD(1:end-1) '_vid_f.mat'],'flow_l')
end
%%
fprintf('4. motion from censor \n');
flow_s = U_readxls(sn);
%%
fprintf('5. motion comparison \n');
match = [1 2 3];
ran = {1:num_f-1,1:num_f-1,1:num_f-1};
%ran = {1:num_f-1,1:num_f-1,1:num_f-1};
for i=1:num_crop
    subplot(num_crop,1,i),cla,hold on
    %imagesc(flow_l{i}(:,:,1,1))
    plot((ran{i}-ran{i}(1))/f0,mean(reshape(bsxfun(@times,flow_l{i}(:,:,1,ran{i}),mask_crop{i}),[],num_f-1),1)*10,'b-')
    plot((ran{i}-ran{i}(1))/f0,mean(reshape(flow_l{i}(:,:,1,ran{i}),[],num_f-1),1),'r-')
    %plot(flow_s{match(i)}{1},flow_s{match(i)}{2},'r-')
end
