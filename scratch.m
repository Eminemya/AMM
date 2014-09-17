nn='100Hz_1000fps_ex_990us_l-FIRWindowBP-band99.00-101.00-sr1000-alpha100-mp1-sigma2-scale1.00-frames1-60-octave-0-60-1.avi';
aa=VideoReader(nn);tmp_vr=aa.read();
save amp_vid tmp_vr
