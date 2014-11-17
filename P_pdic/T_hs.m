do_hs;
opts.pyramid_levels=3;
opts.max_warping_iters=1;
opts.mf=2;
opts.fid=1;

tid = 1;
switch tid
case 1
    im1= rand([100 100 3]);
    im2= im1(:,[3:end 1:2],:);
end

f1 = T_lk_p3(U_r2g(im1), U_r2g(im2),5,5);
f2 = T_lk_p_ms2(im1, im2,opts);
opts2=opts;
opts2.fid=2;opts2.psz_h=5;opts2.max_warping_iters=2;opts2.step_size=0.5;
f3 = T_lk_p_ms2(im1, im2,opts2);
V_feat(cat(3,f1,f2,f3),[],[],[-2 2]);

