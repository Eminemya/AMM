%%
fprintf('Align Sensor Measurement\n')
nns={'50_500_b','100_500_b','100_500_s','50_500_s','0_500'};
f0=500;
%{
do_save=1;do_step1=1;do_step2=0;
for nid=1:5
    D2_lag1010
end

% remove light
%}
nn=nns{nid};
DD = ['data/data_1010/' nn];
do_light=2;

flo_name = [DD '_cell_ur_f' num2str(do_light) '.mat'];
out_name = ['meta_' nn '_algn' num2str(do_light) '.png'];

%{
% look at phase map
out = V_phasemap(vid3,95,105,500);
% check signal
subplot(221)
U_fft(sum(reshape(vid3(ran_e{1},ran_e{2},end-999:end),[],1000),1));
subplot(222)
U_fft(sum(reshape(vid3(ran_e{1},ran_e{2},1:1000),[],1000),1));
% exist a transition in lighting change
subplot(223)
U_fft(sum(reshape(vid3(:,:,end-999:end),[],1000),1));
subplot(224)
U_fft(sum(reshape(vid3(:,:,1:1000),[],1000),1));
%}

%{
do_light=2;
DD = ['data/meta_1010/' nns{2}];
a=[DD '_cell_ur_f' num2str(do_light) '.mat'];
a=load(a,'flow_l');
DD = ['data/meta_1010/' nns{5}];
b=[DD '_cell_ur_f' num2str(do_light) '.mat'];
b=load(b,'flow_l');
rr = 1000:1100;
hold on
plot(mean(reshape(a.flow_l(:,:,1,rr),[],numel(rr))),'b-')
plot(mean(reshape(b.flow_l(:,:,1,rr),[],numel(rr))),'r-')
axis tight,saveas(gca,'100_500_b.png')
%}

if exist(flo_name,'file')
    load(flo_name,'flow_l')
    sz = size(flow_l);
    sz(3) = sz(3)+1;
else
    switch do_light
        case 0
            % original
            load([DD '_cell_ur'],'vid')
            vid2=vid;
        case 1
            % remove 120Hz, 240Hz
            load([DD '_cell_ur'],'vid2')
        case 2
            % remove 60Hz, 140Hz
            load([DD '_cell_ur'],'vid3')
            vid2=vid3;
    end
    sz = size(vid2);
    flow_l = zeros([sz(1:2) 2 sz(3)-1],'single');
    vid3=vid2(:,:,2:end);
    psz=3;
    parfor i = 1:sz(3)-1
        flow_l(:,:,:,i) = T_lk_p3(vid2(:,:,i),vid3(:,:,i),psz);
        %tmp = T_lk_p3(vid2(:,:,i),vid3(:,:,i),psz);
        %flow_l(:,:,:,i) = cat(3,medfilt2(tmp(:,:,1),[3 3]),medfilt2(tmp(:,:,2),[3 3]));
    end
    save(flo_name,'-v7.3','flow_l')
end
ran = 1:1999;
ran_e = {10:20,130:145};
avg_ve =  mean(reshape(flow_l(ran_e{1},ran_e{2},2,:),[],sz(3)-1),1);
avg_ue =  mean(reshape(flow_l(ran_e{1},ran_e{2},1,:),[],sz(3)-1),1);
avg_v =  mean(reshape(flow_l(:,:,2,:),[],sz(3)-1),1);
avg_u =  mean(reshape(flow_l(:,:,1,:),[],sz(3)-1),1);
gt_v = importdata(['data/meta_1010/txt/' nn '2.txt']);
% sensor measurement
%{
a2 = importdata(['data/meta_1010/txt/' nn '2.txt']);
a1 = importdata(['data/meta_1010/txt/' nn '1.txt']);
a0 = importdata(['data/meta_1010/txt/' nn '0.txt']);
clf,hold on;ran=(100:1500)+499;
plot(a2(ran,1),a2(ran,2)/max(a2(:,2)),'b-')

plot(a0(ran,1),a0(ran,2)/max(a0(:,2)),'r-')
plot(a1(ran,1),a1(ran,2)/max(a1(:,2)),'g-')

% plot(ho(1000+(1:100))*10.5,'b-'),hold on,plot(avg_u(1000+(1:100))*10.5,'r-')

%}

%{
subplot(221),plot(avg_u(ran))
subplot(222),plot(avg_v(ran))

subplot(221),plot(avg_ue(ran))
subplot(222),plot(avg_ve(ran))
gt_v = importdata(['data/meta_1010/txt/' nn '2.txt']);
subplot(223),plot(gt_v(ran,2))

subplot(224),cla,hold on
%}

switch nid
    case 1
        ran1=300:1850;
        ran2=528:997;
        amp=10.5;
        pred = avg_u;
    case 2
        pred = avg_ue;
    case 4
        amp=10.5;
        ran1=300:1850;
        ran2=491:960;
        pred = avg_u;
end
clf,hold on
%plot(gt_v(ran1,1),gt_v(ran1,2),'')
plot((gt_v(ran1,1)-gt_v(ran1(1),1)),gt_v(ran1,2),'b-')
plot((ran2-ran2(1))/500,amp*pred(ran2),'r-')
axis tight

saveas(gca,out_name)
