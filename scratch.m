%%
nn='100Hz_1000fps_ex_990us_l-FIRWindowBP-band99.00-101.00-sr1000-alpha100-mp1-sigma2-scale1.00-frames1-60-octave-0-60-1.avi';
aa=VideoReader(nn);tmp_vr=aa.read();
save amp_vid tmp_vr

%%

DD='/Users/Stephen/Code/amm/Results/';
nn={[DD '1100Hz_4700fps_l_dl.-FIRWindowBP-band1089.00-1111.00-sr4700-alpha1000-mp1-sigma2-scale1.00-frames1-100-octave-0-100-1001-0.avi'], ...
[DD '2100Hz_6400fps_l_dl.-FIRWindowBP-band2079.00-2121.00-sr6400-alpha1000-mp1-sigma2-scale1.00-frames1-200-octave-0-200-1001-0.avi'], ...
[DD '3000Hz_11019fps_l_dl.-FIRWindowBP-band2970.00-3030.00-sr11019-alpha1000-mp1-sigma2-scale1.00-frames1-200-octave-0-200-1001-0.avi'], ...
[DD '4300Hz_11019fps_dl.-FIRWindowBP-band4257.00-4343.00-sr11019-alpha1000-mp1-sigma2-scale1.00-frames1-200-octave-0-200-1001-0.avi'] ...
};
out_nn={'1100Hz_1000_0926.gif','2100Hz_1000_0926.gif','3000Hz_1000_0926.gif','4300Hz_1000_0926.gif'};
for nid= 1:numel(nn)
U_avi2gif(nn{nid},out_nn{nid},1);
end
