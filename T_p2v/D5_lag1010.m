%param_init
nns ={'data/struct_0721/50Hz_1000fps_ex_990us_l.avi', ...
    'data/struct_0721/50Hz_1000fps_ex_990us_s.avi', ...
    'data/struct_0721/100Hz_1000fps_ex_990us_l.avi', ...
    'data/struct_0721/100Hz_1000fps_ex_990us_s.avi', ...
    'data/struct_0721/50Hz_1000fps_ex_990us_l-FIRWindowBP-band50.00-51.00-sr1000-alpha10-mp1-sigma2-scale1.00-frames1-60-octave-0-60-1.avi', ...
    'data/struct_0901/3100Hz_11019fps_l_dl.mat', ...
    'data/struct_0901/3640Hz_11019fps_l_dl.mat', ...
    'data/struct_0901/1100Hz_11019fps_l_dl.mat'
    };
ff=[60 60 60 60 0 inf inf inf inf];
amps = [10 100 100 500 0 2000 2000 1000];


nids = 1;%7:8;%1:numel(nns);
fs = [1000 1000 1000 1000 0 11019 11019 11019];
f1 = [50 50 100 100 0 3100 3640 1100];
fl = ceil(f1*0.99);
fh = ceil(f1*1.01);
flo_id=5;
temporalFilter = @FIRWindowBP;

do_step3=0;
do_step4=1; vflo_id=2;
psz=5;
med_psz=[3 3];
for nid = nids
    if ~exist(sprintf('flo_%d_%d_%d.mat',flo_id,nid,ff(nid)),'file')
        fprintf('video: %d, %d frames.\n',nid,ff(nid))
        tmp_vr =[];
        if nns{nid}(end)=='i'
            vid = VideoReader(nns{nid});
            tmp_vr = vid.read([1 ff(nid)]);
            tmp_vr = single(tmp_vr)/255;
            % band pass
            vid1 = U_remove120(cat(3,tmp_vr,tmp_vr,tmp_vr),115,125,fs(nid));
            tmp_vr = U_remove120(vid1,235,245,fs(nid));
            
        else
            load(nns{nid});
        end
        sz = size(tmp_vr);
        if(sz(3)==3);sz(3)=1;tmp_vr=tmp_vr(:,:,1,:);end
        
        flo = zeros([sz(1:2) 2 sz(end)-1]);
        %if isinf(ff(nid));ff(nid)=sz(end);end
        tmp_vr2= tmp_vr(:,:,:,2:end);
        parfor i=1:sz(end)-1
            %flo(:,:,:,i) = T_lk_p3(tmp_vr(:,:,:,1),tmp_vr2(:,:,:,1),psz);
            tmp = T_lk_p3(tmp_vr(:,:,:,i),tmp_vr2(:,:,:,i),psz);
            flo(:,:,:,i) = cat(3,medfilt2(tmp(:,:,1),med_psz),medfilt2(tmp(:,:,2),med_psz));
            %{
         imagesc(flowToColor(flo(:,:,:,1)))
         
         imagesc([double(tmp_vr(:,:,1,i))/255-flo(:,:,3,i) ...
                double(tmp_vr(:,:,1,i+1))/255-flo(:,:,3,i) ...
                double(tmp_vr(:,:,1,i))/255-double(tmp_vr(:,:,1,i+1))/255])
         % too small motion
         U_ims2gif(cat(3,warp*255,tmp_vr(:,:,1,i)),'tmp1.gif')
         U_ims2gif(cat(3,warp*255,tmp_vr(:,:,1,i+1)),'tmp2.gif')
         U_ims2gif(tmp_vr(:,:,1,i:i+1),'tmp0.gif')
            %}
        end
        save(sprintf('flo_%d_%d_%d.mat',flo_id,nid,ff(nid)),'-v7.3','flo')
    else
        if nns{nid}(end)=='i'
            vid = VideoReader(nns{nid});
            tmp_vr = vid.read([1 ff(nid)]);
        else
            load(nns{nid});
        end
        sz = size(tmp_vr);
        if(sz(3)==3);sz(3)=1;tmp_vr=tmp_vr(:,:,1,:);end
        load(sprintf('flo_%d_%d_%d.mat',flo_id,nid,ff(nid)),'flo')
    end
    
    if fs(nid)~=0
        flo(:,:,1,:) = temporalFilter(squeeze(flo(:,:,1,:)), fl(nid)/fs(nid),fh(nid)/fs(nid));
        flo(:,:,2,:) = temporalFilter(squeeze(flo(:,:,2,:)), fl(nid)/fs(nid),fh(nid)/fs(nid));
    end
    %{
%avg_f = squeeze(mean(mean(abs(flo))));
%ran =[1 180 1 180];
ran =[160 340 840 1020];
avg_f = squeeze(mean(mean(abs(flo(ran(1):ran(2),ran(3):ran(4),:,:)))));
plot(avg_f(1:2,:)')
    %}
    
    if do_step4
        v_flo = zeros([sz(1:2),3,sz(end)-1]);
        max_flo = max(reshape(sqrt(sum(flo(:,:,1:2,:).^2,3)),1,[]));
        %max_flo = prctile(reshape(sqrt(sum(flo(:,:,1:2,:).^2,3)),1,[]),80);
        switch vflo_id
            case 1
                % colormap
                parfor i= 1:max(59,sz(end)-1)
                    v_flo(:,:,:,i) = flowToColor(flo(:,:,1:2,i),max_flo);
                end
            case 2
                % colormap+arrow
                ballSpacing = 50;
                %mm = colormap('jet');
                for i= 1:max(59,sz(end)-1)
                    clf
                    axis(0.5+[0 sz(2) 0 sz(1)])
                    %imagesc(sqrt(sum(flo(:,:,1:2,i).^2,3))/max_flo),caxis([0 max_flo])
                    %hold on,axis off,axis tight,axis equal
                    % M2: external arrow drawer
                    % V_quiver2(flo(:,:,1:2,i)/max_flo,ballSpacing,[500,250],4);
                    % M1: quiver + annotation
                    h = V_quiver(flo(:,:,1:2,i)/max_flo,ballSpacing);
                    %imshow(ind2rgb(gray2ind(uint8(255*sqrt(sum(flo(:,:,1:2,i).^2,3))/max_flo),255),jet(255)))
                    tmp_im = ind2rgb(gray2ind(uint8(255*sqrt(sum(flo(:,:,1:2,i).^2,3))/max_flo),255),jet(255));
                    %U_arrowhead(h,2)
                    U_arrowhead2(h,10,tmp_im);
                    % clf,h = V_quiver(cat(3,zeros(4),ones(4)),1);axis([0 5 0 5]),U_arrowhead2(h,10);
                    % clf,h = V_quiver(cat(3,ones(4),ones(4)),1);axis([0 5 0 5]),U_arrowhead2(h,10);
                    % clf,h = V_quiver(cat(3,[ones(2,4);zeros(2,4)],ones(4)),1);axis([0 5 0 5]),U_arrowhead2(h,10);
                    a=getframe;
                    v_flo(:,:,:,i) = imresize(a.cdata,sz(1:2),'nearest');
                end
            case 3
                % arrow
                ballSpacing = 50;
                %mm = colormap('jet');
                for i= 1:max(59,sz(end)-1)
                    clf
                    axis(0.5+[0 sz(2) 0 sz(1)])
                    %imagesc(sqrt(sum(flo(:,:,1:2,i).^2,3))/max_flo),caxis([0 max_flo])
                    %hold on,axis off,axis tight,axis equal
                    tmp_im = ind2rgb(gray2ind(uint8(255*sqrt(mean(flo(:,:,1:2,i).^2,3))/max_flo),255),jet(255));
                    % M2: external arrow drawer
                    % V_quiver2(flo(:,:,1:2,i)/max_flo,ballSpacing,[500,250],4);
                    % M1: quiver + annotation
                    imshow(tmp_im),hold on
                    h = V_quiver(flo(:,:,1:2,i)/max_flo,ballSpacing);
                    %imshow(ind2rgb(gray2ind(uint8(255*sqrt(sum(flo(:,:,1:2,i).^2,3))/max_flo),255),jet(255)))
                    
                    %U_arrowhead(h,2)
                    %U_arrowhead2(h,10,tmp_im);
                    % clf,h = V_quiver(cat(3,zeros(4),ones(4)),1);axis([0 5 0 5]),U_arrowhead2(h,10);
                    % clf,h = V_quiver(cat(3,ones(4),ones(4)),1);axis([0 5 0 5]),U_arrowhead2(h,10);
                    % clf,h = V_quiver(cat(3,[ones(2,4);zeros(2,4)],ones(4)),1);axis([0 5 0 5]),U_arrowhead2(h,10);
                    a=getframe;
                    v_flo(:,:,:,i) = imresize(a.cdata,sz(1:2),'nearest');
                end
        end
        %U_ims2gif(uint8(v_flo),sprintf('lag_meta_flo_%d_%d_%d_%.2f.gif',nid,vflo_id,fs(nid),max_flo),0,0.03)
        U_ims2gif(uint8(v_flo),sprintf('lk_%d_%d.gif',vflo_id,30),0,0.03)
        U_ims2gif(uint8(v_flo),sprintf('lk_%d_%d.gif',vflo_id,10),0,0.1)
        U_ims2gif(uint8(v_flo),sprintf('lk_%d_%d.gif',vflo_id,3),0,0.3)
        
        % add the mask
        load('meta_mask');mask = (V_x<5|V_y<5);
        U_ims2gif(uint8(bsxfun(@times,v_flo,cat(3,mask,mask,mask))),sprintf('lkm_%d_%d.gif',vflo_id,10),0,0.1)
    end
end

%{
nid=1;
flo_id=1;
f1 = load(sprintf('flo_%d_%d_%d.mat',flo_id,nid,ff(nid)),'flo')
flo_id=5;
f2 = load(sprintf('flo_%d_%d_%d.mat',flo_id,nid,ff(nid)),'flo')
sz=size(f2.flo)
v_flo1 = zeros([sz(1:2),3,sz(end)-1]);
v_flo2 = zeros([sz(1:2),3,sz(end)-1]);
max_flo = max(reshape(sqrt(sum(f1.flo(:,:,1:2,:).^2,3)),1,[]));
max_flo = max(reshape(sqrt(sum(f2.flo(:,:,1:2,:).^2,3)),1,[]));
max_flo = max(max_flo,max(reshape(sqrt(sum(f2.flo(:,:,1:2,:).^2,3)),1,[])));

parfor i= 1:max(59,sz(end)-1)
    %v_flo1(:,:,:,i) = flowToColor(f1.flo(:,:,1:2,i),max_flo);
    v_flo2(:,:,:,i) = flowToColor(f2.flo(:,:,1:2,i),max_flo);
end

U_ims2gif(uint8([v_flo1 v_flo2]),sprintf('lk_%d_%d.gif',vflo_id,3),0,0.3)
U_ims2gif(uint8([v_flo1 v_flo2]),sprintf('lk_%d_%d.gif',vflo_id,10),0,0.1)

U_ims2gif(uint8([v_flo2 ]),sprintf('lk_%d_%d.gif',vflo_id,3),0,0.3)
U_ims2gif(uint8([v_flo2 ]),sprintf('lk_%d_%d.gif',vflo_id,10),0,0.1)


v_flo3=v_flo;
U_ims2gif(uint8(v_flo3),sprintf('lk_%d_%d_mrf_a.gif',vflo_id,3),0,0.3)
U_ims2gif(uint8(v_flo3),sprintf('lk_%d_%d_mrf_a.gif',vflo_id,10),0,0.1)


% phase
out = V_phasemap(squeeze(f1.flo(:,:,1,:)),fl(nid),fh(nid),fs(nid));
sz=size(out);
out2 = zeros([sz(1:2) 3 sz(3)]);
for i=1:size(out,3)
    out2(:,:,:,i) =V_im2jet(out(:,:,i),2*pi);
end
U_ims2gif([out2 ],sprintf('lk_%d_%d_pm.gif',vflo_id,3),0,0.3)
U_ims2gif([out2 ],sprintf('lk_%d_%d_pm.gif',vflo_id,10),0,0.1)


tmp_im = ind2rgb(gray2ind(uint8(255*sqrt(mean(flo(:,:,1:2,i).^2,3))/max_flo),255),jet(255));


% energy decay
nid=3;
flo_id=1;
f3 = load(sprintf('flo_%d_%d_%d.mat',flo_id,nid,ff(nid)),'flo')
f3_h = FIRWindowBP(squeeze(f3.flo(:,:,1,:)), fl(nid)/fs(nid),fh(nid)/fs(nid));
f3_v = FIRWindowBP(squeeze(f3.flo(:,:,2,:)), fl(nid)/fs(nid),fh(nid)/fs(nid));
out = reshape(f3_h.^2+f3_v.^2,[],sz(end));
E = reshape(max(out,[],2),sz(1:2));
imagesc(log(E)),colorbar,axis equal,axis off
saveas(gca,'meta_decay.png')
plot(E(100,:))
%}


%{
out=V_getBall2(tmp_vr2,10*flo);
U_ims2gif(out,sprintf('lagv_meta_%d.gif',amp),0,0.03)
%}
%{
% quiver plot
[yy,xx] = meshgrid(1:sz(2),1:sz(1));
mat_ind = reshape(1:prod(sz(1:2)),sz(1:2));
ballSpacing = 20;
ballRad = 3;
ball_ind = reshape(mat_ind(ballSpacing:ballSpacing:end,ballSpacing:ballSpacing:end),[],1);
ballPositions = [yy(ball_ind) xx(ball_ind)];
i=1
flo_i = reshape(flo(:,:,1:2,i),[],2)*100;
flo_i(:,)
quiver(yy(ball_ind),xx(ball_ind),flo_i(ball_ind,2),flo_i(ball_ind,1),0,'Color','k')
%}

%{
nid = 2;
nn = nns{nid};nf=ff(nid);
nn = '../0916/Results/struct_0721/100Hz_1000fps_ex_990us_l-FIRWindowBP-band100.00-101.00-sr1000-alpha100-mp1-sigma2-scale1.00-frames1-60-octave-0-60-1.avi'
nf=60;
vid = VideoReader(nn);
tmp_vr = vid.read([1 nf]);
U_ims2gif(tmp_vr,sprintf('euler_meta_%d.gif',amp),0,0.03)

%}