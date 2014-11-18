opts.unEqualSampling=0;
opts.display=0;
opts.interpolation_method='cubic';
opts.deriv_filter = [ 0.0833   -0.6667         0    0.6667   -0.0833];
opts.step_size = 1;
opts.pyramid_spacing=2;
opts.max_warping_iters=1;
opts.mf = 2;%0: no filter, 1: iterative filter, 2:only once at each scale
opts.psz=[16 16];
opts.median_filter_size=5;
opts.max_du=3;

