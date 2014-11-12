param_init

phase_sc=2;phase_or=1;
%fns=dir('data/*_dl.mat');fns = {fns.name};
%fns = {'0Hz_11019fps_0_dl.mat','0Hz_11019fps_1_dl.mat'};

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fprintf('1. create data\n')
if do_step1
    fid = 1;
    fns = {'data/simu/meta.jpg'};
    im = im2single(imread(fns{fid}));
    sz = size(im);
    [yy,xx]=meshgrid(1:sz(2),1:sz(1));
    switch mid
        case 1
            v = [0 1];
        case 2
            v = [1 1];
        case 3
            v = [1 0];
        case 4
            v = [1 -1];
    end
    v= v* v_sc;
    im = cat(4,interp2(im,yy+v(2),xx+v(1)),im);
    im(isnan(im))=0;
    if 0 && do_save
        U_ims2gif(uint8(255*im),['P2v_' num2str(mid) '_im.gif'])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fprintf('2. visualize decomposition\n')
if do_step2
    [buildPyr, ~] = octave4PyrFunctions(23,23);
    impulse = zeros(23,23);
    impulse(12,12) = 1;
    [impulseResponse, pind1] = buildPyr(impulse);
    for k = 1:4
        imwrite(U_visualim(real(pyrBand(impulseResponse, pind1, k+1))),[sprintf('filter_%d.png',k)]);
    end
    
    [buildPyr, ~] = octave4PyrFunctions(size(im,1), size(im,2));
    [pyr, pind2] = buildPyr(mean(im2single(im(:,:,:,1)),3));
    
    num_or = 4;
    num_sc = 5;
    for sc = 1:num_sc
        for or = 1:num_or
            subplot(num_sc,num_or,(sc-1)*num_or+or)
            imagesc(abs(pyrBand(pyr,pind2, (sc-1)*num_or+or+1)));
            axis equal
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fprintf('3. get phase\n')
if do_step3
    addpath(genpath('../0916/MotionHDR/Code/matlab/'))
    frame = mean(im(:,:,:,1),3);
    frame2 = mean(im(:,:,:,2),3);
    
    %orientations = 4;
    [buildPyr,~] = U_octphase(size(frame,1), size(frame,2),orientations);
    [pyr, pind] = buildPyr(frame);
    pyr2 = buildPyr(frame2);
    %imagesc(abs(pyrBand(pyr,pind, 10)))
    
    sampleBand = pyrBand(pyr, pind, 2);
    h = size(sampleBand,1);
    w = size(sampleBand,2);
    %V = zeros(2,2,h, w,'single'); % Precision matrix
    %E = zeros(2,1,h, w,'single'); % Precision matrix
    V = cell(1,numel(bandIDX)); % Precision matrix
    E = cell(1,numel(bandIDX)); % Precision matrix
    u = cell(2,numel(bandIDX)); % Precision matrix
    
    % multi-scale
    Vall = zeros(2,2,h, w,'single');
    Eall= zeros([2 1 h w],'single');
    noiseSigma = 1;
    for l = 1:numel(bandIDX)
        fprintf('Process Level %d\n',bandIDX(l));
        currentBand = pyrBand(pyr,pind, bandIDX(l));
        currentBand2 = pyrBand(pyr2,pind, bandIDX(l));
        
        %{
        Sx{l} = imag(convn(currentBand,[ 1 -1],'same')./(eps+currentBand));
        Sy{l} = imag(convn(currentBand,[ 1 -1]','same')./(eps+currentBand));
        St{l} = mod(pi+angle(currentBand2)-angle(currentBand),2*pi)-pi;
        %}
        [Sx{l},Sy{l}] = gradient(angle(currentBand));
        St{l} = angle(currentBand2)-angle(currentBand);
        
        pre_sz = size(Sx{l});
        
        %levelAmp{l} = abs(currentBand);
        %phit_SD{l}  = predictedRatio(bandIDX(l))*noiseSigma./levelAmp{l};
        phit_SD{l}  = noiseSigma;
        temp1X{l} = Sx{l}./phit_SD{l};
        temp1Y{l} = Sy{l}./phit_SD{l};
        temp1T{l} = St{l}./phit_SD{l};
        
        
        % Precision matrix
        V{l} = zeros([2 2 pre_sz],'single');
        V{l}(1,1,:,:) = reshape(temp1X{l}.^2, [1,1, pre_sz]);
        V{l}(2,2,:,:) = reshape(temp1Y{l}.^2,[1,1, pre_sz]);
        V{l}(1,2,:,:) = reshape(temp1X{l}.*temp1Y{l}, [1,1, pre_sz]);
        V{l}(2,1,:,:) = V{l}(1,2,:,:);
        E{l} = zeros([2 1 pre_sz],'single');
        E{l}(1,1,:,:) =  temp1T{l}.*temp1X{l};
        E{l}(2,1,:,:) =  temp1T{l}.*temp1Y{l};
        
        temp1X{l} = imresize(temp1X{l},[h w],'lanczos3')*w/pre_sz(2);
        temp1Y{l} = imresize(temp1Y{l},[h w],'lanczos3')*h/pre_sz(1);
        temp1T{l} = imresize(temp1T{l},[h w],'lanczos3');
        
        Vall(1,1,:,:) = Vall(1,1,:,:) + reshape(temp1X{l}.^2, [1,1, h w]);
        Vall(2,2,:,:) = Vall(2,2,:,:) + reshape(temp1Y{l}.^2, [1,1, h w]);
        Vall(1,2,:,:) = Vall(1,2,:,:) + reshape(temp1X{l}.*temp1Y{l}, [1,1, h w]);
        
        
        Eall(1,1,:,:) =  Eall(1,1,:,:) + reshape(temp1T{l}.*temp1X{l}, [1 1 , h w])*(w/pre_sz(2))^2;
        Eall(2,1,:,:) =  Eall(2,1,:,:) + reshape(temp1T{l}.*temp1Y{l}, [1 1 , h w])*(h/pre_sz(1))^2;
        
        %{
        E{l} = zeros([2 1 h w],'single');
        E{l}(1,1,:,:) =  reshape(temp1T{l}.*temp1X{l}, [1 1 , h w])*2*w/pre_sz(2);
        E{l}(2,1,:,:) =  reshape(temp1T{l}.*temp1Y{l}, [1 1 , h w])*2*h/pre_sz(1);
        %}
        %{
        % not doable due to lack of rank
        u{2,l} = zeros([pre_sz 2],'single');
        u{1,l} = zeros([h,w 2],'single');
        det = 1./(V(1,1,:,:).*V(2,2,:,:)-V(1,2,:,:).^2);
        u{1,l}(:,:,1) = (V(2,2,:,:).*E(1,1,:,:)-V(1,2,:,:).*E(2,1,:,:)).*det;
        u{1,l}(:,:,2) = (-V(1,2,:,:).*E(1,1,:,:)+V(1,1,:,:).*E(2,1,:,:)).*det;
        %}
    end
    Vall(2,1,:,:) = Vall(1,2,:,:);
    mu = zeros(2,1,h,w,'single');
    warning('off');
    postProb =zeros(numel(bandIDX), h,w,'single');
    mu = zeros(2,1,h,w,'single');
    % local motion evidence
    det = 1./(Vall(1,1,:,:).*Vall(2,2,:,:)-Vall(1,2,:,:).^2);
    mu(1,1,:,:) = -(Vall(2,2,:,:).*Eall(1,1,:,:)-Vall(1,2,:,:).*Eall(2,1,:,:)).*det;
    mu(2,1,:,:) = -(-Vall(1,2,:,:).*Eall(1,1,:,:)+Vall(1,1,:,:).*Eall(2,1,:,:)).*det;
    u = permute(squeeze(mu),[2 3 1 ]);
    u_thres = v_sc*2;
    u(abs(u)>u_thres)=sign(u(abs(u)>u_thres))*u_thres;
    %V_feat(u,[],[],[0 1])
    
    
    %{
    parfor j = 1:size(V,3)
        parfor k = 1:size(V,4)
            mu(:,:,j,k) = V(:,:,j,k)\E(:,:,j,k);
        end
    end
    %}
    %{
    for l = 1:numel(bandIDX)
        %postProb(l,:,:) = 1./(sqrt(2*pi)*phit_SD{l}).*exp(-(Sx{l}.*squeeze(mu(1,1,:,:))+Sy{l}.*squeeze(mu(2,1,:,:))-temp1T{l}).^2./(2*phit_SD{l}.^2));
        postProb(l,:,:) = abs(Sx{l}.*squeeze(mu(1,1,:,:))+Sy{l}.*squeeze(mu(2,1,:,:))-St{l})./(phit_SD{l});
    end
    %}
    % 2. local motion evidence
    covMats = bsxfun(@times,Vall,det);
    covMats(1,2,:,:) = covMats(1,2,:,:);
    covMats(2,1,:,:) = covMats(2,1,:,:);
    tmp = covMats(1,1,:,:);
    covMats(1,1,:,:) = -covMats(2,2,:,:);
    covMats(2,2,:,:) = tmp;
    
    if do_save
        %{
        figure(1)
        subplot(211),imagesc(u(:,:,1)-v(2),[-1 1]),colorbar,axis equal,axis off
        subplot(212),imagesc(u(:,:,2)-v(1),[-1 1]),colorbar,axis equal,axis off
        saveas(gcf,sprintf('P2v_%d_%d_%d_%d_uerr.png',mid,orientations,scales,ceil(100*v_sc)))
        cscale =  0.5;
        subplot(211),imagesc(squeeze(sqrt(abs(covMats(1,1,:,:)))),[-cscale cscale]),colorbar,axis equal,axis off
        subplot(212),imagesc(squeeze(sqrt(abs(covMats(2,2,:,:)))),[-cscale cscale]),colorbar,axis equal,axis off
        saveas(gcf,sprintf('P2v_%d_%d_%d_%d_cov.png',mid,orientations,scales,ceil(100*v_sc)))
        %}
        figure(2)
        subplot(211),hist((reshape(u(:,:,1)-v(2),1,[])))
        axis([-3*v_sc 3*v_sc 0 15e4])
        subplot(212),hist((reshape(u(:,:,2)-v(1),1,[])))
        axis([-3*v_sc 3*v_sc 0 15e4])
        saveas(gcf,sprintf('P2v_%d_%d_%d_%d_ulerr.png',mid,orientations,scales,ceil(100*v_sc)))
        
        
        
    end
end
%% step 4
if do_step4
    % for each scale and orientation
    frame = mean(im(:,:,:,1),3);
    frame2 = mean(im(:,:,:,2),3);
    
    %orientations = 4;
    [buildPyr,~] = U_octphase(size(frame,1), size(frame,2),orientations);
    [pyr, pind] = buildPyr(frame);
    pyr2 = buildPyr(frame2);
    data = [];
    figure(1),cla,hold on
    ww=1.5*v_sc;
    axis([-ww ww -ww ww])
    
    lu = T_lk2(im(:,:,:,1),im(:,:,:,2));
    %lu_l = T_lk_p(im(:,:,:,1),im(:,:,:,2),3);
    plot(lu(1),lu(2),'co','MarkerSize',15)
    plot(v(2),v(1),'rx','MarkerSize',15)
    c_sc='gbk';c_or='>v<^';
    uu=zeros(scales,orientations,2);
    for sc = 1:scales
        for or = 1:orientations
            bid = (sc-1)*4+or+1;
            im1 = pyrBand(pyr,pind,bid);im2 = pyrBand(pyr2,pind,bid);
            pre_sz = size(im1);
            %[bid T_lk2(angle(im1),angle(im2))']
            [tmp_mu,tmp_pre] = T_lk2(angle(im1),angle(im2),num_step);
            data.mu = (sz./pre_sz)'.*tmp_mu;
            %data.precisionMatrix = ((sz./pre_sz)*(sz./pre_sz)')*tmp_pre;
            %u = T_lk2(abs(im1),abs(im2));
            plot(data.mu(1),data.mu(2),[c_sc(sc) c_or(or)],'MarkerSize',15)
            %V_contour(data,1,1,c_sc(sc));
            uu(sc,or,:) = data.mu;
        end
    end
    set(gca,'FontSize',20)
    saveas(gcf,sprintf('P2v_%d_%d_%d_gm.png',mid,num_step,ceil(100*v_sc)))
end
%%
if do_step5
    %{
    % individual band
    %sum(reshape(Vall,2,2,[]),3)\sum(reshape(Eall,2,[]),2)
    us2 = zeros(numel(bandIDX),2);
    for l = 1:numel(bandIDX)
        pre_sz = size(Sx{l});
        us2(l,:) = (sz./pre_sz).*(sum(reshape(V{l},2,2,[]),3)\sum(reshape(E{l},2,[]),2))';
    end
    %}
    
    % multi orientation
    us = zeros(scales,2);
    for sc = 1:scales
        VV = zeros(2,2);
        pre_sz = size(V{(sc-1)*orientations+1});
        pre_sz = pre_sz(3:4);
        EE = zeros(2,1);        
        for l = 1:orientations
            bid = (sc-1)*orientations+l;
            VV = VV + sum(reshape(V{bid},2,2,[]),3);
            EE = EE + sum(reshape(E{bid},2,[]),2);
        end
        us(sc,:) = (sz./pre_sz).*(VV\EE)';
    end
    figure(1),cla,hold on
    ww=1.5*v_sc;
    axis([-ww ww -ww ww])
    plot(v(2),v(1),'rx','MarkerSize',15)
    c_sc='gbk';c_or='>v<^';    
    for sc = 1:scales
        plot(us(sc,2),us(sc,1),[c_sc(sc) 'o'],'MarkerSize',15)
    end
    % multi scale
    uall = sum(reshape(Vall,2,2,[]),3)\sum(reshape(Eall,2,1,[]),3);
    plot(us(sc,2),us(sc,1),[c_sc(sc) 'o'],'MarkerSize',15)
    
    
end


%%
if do_step6
    clf,hold on
    lu = T_lk2(im(:,:,:,1),im(:,:,:,2));
    %lu_l = T_lk_p(im(:,:,:,1),im(:,:,:,2),3);
    plot(lu(1),lu(2),'co')
    plot(v(2),v(1),'rx')
    c_sc='gbk';c_or='>v<^';
    num_sc=3;num_or=4;
    uu=zeros(num_sc,num_or,2);
    for sc = 1:3
        for or = 1:4
            bid = (sc-1)*4+or+1;
            im1 = pyrBand(pyr,pind,bid);im2 = pyrBand(pyr2,pind,bid);
            %[bid T_lk2(angle(im1),angle(im2))']
            u = sc*T_lk2(angle(im1),angle(im2),1);
            %u = T_lk2(abs(im1),abs(im2));
            plot(u(1),u(2),[c_sc(sc) c_or(or)])
            %u = sc*T_lk_p(angle(im1),angle(im2),1);
            uu(sc,or,:) = u;
        end
    end
    saveas(gcf,sprintf('Lag_%d_%d_gm.png',mid,ceil(100*v_sc)))
end