function uv = T_lk_p_ms2(im1,im2,opts, init)

% Frame size
psz = opts.psz;
images= cat(4,im1,im2);
sz = [size(im1, 1), size(im1, 2)];

% If we have no initialization argument, initialize with all zeros
if (nargin < 4)
    uv = zeros([sz, 2]);
else
    uv = init;
end

factor            = 2;%sqrt(2);  % sqrt(3)

if opts.unEqualSampling
    opts.pyramid_levels  =  1 + floor( log(max(sz)/16)...
        / log(opts.pyramid_spacing) );
    
    tmp = exp(log(min(sz)/max(sz)*opts.pyramid_spacing^(opts.pyramid_levels-1))...
        /(opts.pyramid_levels-1) );
    if sz(1) > sz(2)
        spacing = [opts.pyramid_spacing tmp];
    else
        spacing = [tmp opts.pyramid_spacing];
    end
    
    fprintf('unequal sampling\n');
    pyramid_images    = compute_image_pyramid_unequal(images, ...
        opts.pyramid_levels, spacing, factor);
else
    if ~exist('opts.pyramid_levels','var') || opts.pyramid_levels==0
    % Automatic determine pyramid level
    % largest size around
    min_sz = [50 20];
    N1 = 1 + floor( log(max(sz)/min_sz(1))/...
        log(opts.pyramid_spacing) );
    % smaller size shouldn't be less than 6
    N2 = 1 + floor( log(min(sz)/min_sz(2))/...
        log(opts.pyramid_spacing) );

    % satisfies at least one(N2)
    opts.pyramid_levels  =  min(N1, N2);
    end

    % Construct image pyramid, using setting in Bruhn et al in  "Lucas/Kanade.." (IJCV2005') page 218
    smooth_sigma      = sqrt(opts.pyramid_spacing)/factor;   % or sqrt(3) recommended by Manuel Werlberger
    f                 = fspecial('gaussian', 2*round(1.5*smooth_sigma) +1, smooth_sigma);
    pyramid_images    = compute_image_pyramid(images, f, opts.pyramid_levels, 1/opts.pyramid_spacing);
end

if opts.display
    fprintf('%d-level pyramid used\n', opts.pyramid_levels);
end


% Iterate through all pyramid levels starting at the top
switch opts.fid
    case 0
        % HS
        L     = [0 1 0; 1 -4 1; 0 1 0];     % Laplacian operator
        for l = opts.pyramid_levels:-1:1
            if opts.display
                disp(['Pyramid level: ', num2str(l)])
            end
            
            % Scale flow to the current pyramid level
            sz2 = size(pyramid_images{l});sz2 = sz2(1:2);
            %uv    =  resample_flow_unequal(uv,sz2);
            uv    =  resample_flow_unequal(uv,sz2,'nearest');
            
            %num_p = prod(sz2-psz+1);
            num_p = prod(sz./psz);
            psz2 = psz*factor^(1-l);
            npixels   = prod(sz2);
            p_ind = im2col(reshape(1:npixels,sz2), psz2,'distinct');
            F0 = make_imfilter_mat(L, psz2, 'replicate', 'same');
            F     =  kron(eye(num_p),F0);
            
            for iter=1:opts.max_warping_iters
                [It,Ix,Iy] = partial_deriv(pyramid_images{l}, uv, opts.interpolation_method, opts.deriv_filter);
                % Spatial/prior term
                
                % Replicate operator for u and v
                M     = [F, sparse(npixels, npixels);
                    sparse(npixels, npixels), F];
                % For color processing
                Ix2 = mean(Ix.^2, 3);
                Iy2 = mean(Iy.^2, 3);
                Ixy = mean(Ix.*Iy, 3);
                Itx = mean(It.*Ix, 3);
                Ity = mean(It.*Iy, 3);
                % gaussian filter to aggregate
                
                duu   = spdiags(Ix2(p_ind(:)), 0, npixels, npixels);
                dvv   = spdiags(Iy2(p_ind(:)), 0, npixels, npixels);
                duv   = spdiags(Ixy(p_ind(:)), 0, npixels, npixels);
                
                % Compute the operator
                A     = [duu duv; duv dvv] - M*opts.sigmaS2;
                b     = M*uv([p_ind(:);npixels+p_ind(:)])*opts.sigmaS2 - [Itx(p_ind(:)); Ity(p_ind(:))];
                rr    = reshape(A\b,prod(psz2),num_p,2);
                rr(abs(rr)>max(psz2))=nan;
                % Generate copy of algorithm with single pyramid level and the appropriate subsampling
                uv = uv+opts.step_size*rr;
                if opts.mf==1
                    uv = U_medfilt2(uv,opts.median_filter_size);
                end
            end
            if opts.mf==2
                    uv = U_medfilt2(uv,opts.median_filter_size);
            end
            if opts.display
                V_feat(uv,[],[],1)
                keyboard
            end
        end
    case 1
        % LK on pixel (already pre-smooth the image)
        %sum_p = ones(2*psz_h+1);
        
        for l = opts.pyramid_levels:-1:1
            if opts.display
                disp(['Pyramid level: ', num2str(l)])
            end
            
            % Scale flow to the current pyramid level
            sz2 = size(pyramid_images{l});sz2 = sz2(1:2);
            uv    =  resample_flow_unequal(uv,sz2);
            %uv    =  resample_flow_unequal(uv,sz2,'nearest');
            for iter=1:opts.max_warping_iters
                [It,Ix,Iy] = partial_deriv(pyramid_images{l}, uv, opts.interpolation_method, opts.deriv_filter);
                % For color processing
                Vxx = mean(Ix.^2, 3);
                Vyy = mean(Iy.^2, 3);
                Vxy = mean(Ix.*Iy, 3);
                Ext = mean(It.*Ix, 3);
                Eyt = mean(It.*Iy, 3);
                det = 1./(Vxx.*Vyy-Vxy.^2);
                V= [reshape(det.*Vyy,1,[]);reshape(det.*Vxx,1,[])];
                du = uv;
                du(:,:,1) = -reshape((Vyy.*Ext-Vxy.*Eyt).*det,sz2);
                du(:,:,2) = -reshape((-Vxy.*Ext+Vxx.*Eyt).*det,sz2);
                du(abs(du)>max(opts.max_du)) = 0;
                du(isnan(du)) = 0;
                [l iter nnz(isnan(du)) nnz(isnan(uv))]
                % Generate copy of algorithm with single pyramid level and the appropriate subsampling
                uv = uv+opts.step_size*du;
                if opts.mf==1
                    uv = U_medfilt2(uv,opts.median_filter_size);
                end
            end
            if opts.mf==2
                    uv = U_medfilt2(uv,opts.median_filter_size);
            end
            if opts.display
                V_feat(uv,[],[],1)
                keyboard
            end
        end
    case 2
        % LK on patch (already pre-smooth the image)
        psz_h = opts.psz_h;
        
        for l = opts.pyramid_levels:-1:1
            psz_h2 = ceil(psz_h*factor^(1-l));
            sum_p = fspecial('gaussian',2*psz_h2+1,1);
            if opts.display
                disp(['Pyramid level: ', num2str(l)])
            end
            
            % Scale flow to the current pyramid level
            sz2 = size(pyramid_images{l});sz2 = sz2(1:2);
            uv    =  resample_flow_unequal(uv,sz2);
            %uv    =  resample_flow_unequal(uv,sz2,'nearest');
            for iter=1:opts.max_warping_iters
                [It,Ix,Iy] = partial_deriv(pyramid_images{l}, uv, opts.interpolation_method, opts.deriv_filter);

                % For color processing
                Ix2 = padarray(mean(Ix.^2, 3),[psz_h2 psz_h2],'replicate');
                Iy2 = padarray(mean(Iy.^2, 3),[psz_h2 psz_h2],'replicate');
                Ixy = padarray(mean(Ix.*Iy, 3),[psz_h2 psz_h2],'replicate');
                Itx = padarray(mean(It.*Ix, 3),[psz_h2 psz_h2],'replicate');
                Ity = padarray(mean(It.*Iy, 3),[psz_h2 psz_h2],'replicate');
                
                Vxx = conv2(Ix2,sum_p,'valid');
                Vxy = conv2(Ixy,sum_p,'valid');
                Vyy = conv2(Iy2,sum_p,'valid');
                Ext = conv2(Itx,sum_p,'valid');
                Eyt = conv2(Ity,sum_p,'valid');
                
                det = 1./(Vxx.*Vyy-Vxy.^2);
                V= [reshape(det.*Vyy,1,[]);reshape(det.*Vxx,1,[])];
                du = uv;
                du(:,:,1) = -reshape((Vyy.*Ext-Vxy.*Eyt).*det,sz2);
                du(:,:,2) = -reshape((-Vxy.*Ext+Vxx.*Eyt).*det,sz2);
                % Generate copy of algorithm with single pyramid level and the appropriate subsampling
                du(abs(du)>max(opts.max_du)) = 0;
                du(isnan(du)) = 0;
                uv = uv+opts.step_size*du;
                if opts.mf==1
                    uv = U_medfilt2(uv,opts.median_filter_size);
                end
            end
            if opts.mf==2
                %keyboard
                uv = U_medfilt2(uv,opts.median_filter_size);
            end
            if opts.display
                V_feat(uv,[],[],1)
                keyboard
            end
        end
end

