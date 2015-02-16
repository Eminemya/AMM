function tmp_f = U_of(tmp_v)
alpha = 0.05;
ratio = 0.5;
minWidth = 100;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

sz =size(tmp_v);
num_f = sz(end);
tmp_f = zeros([sz(1:2) 2 num_f-1]);
tmp_v2 = tmp_v(:,:,2:end);
parfor i =1:num_f-1
    [a,b] = Coarse2FineTwoFrames(tmp_v(:,:,i),tmp_v2(:,:,i),para);
    tmp_f(:,:,:,i) = cat(3,a,b);
end