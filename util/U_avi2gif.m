function U_avi2gif(f1,f2,dtime)
vr = VideoReader(f1);
ims = vr.read();
if exist('dtime','var')
U_ims2gif(ims,f2,0,dtime);
else
U_ims2gif(ims,f2);
end
