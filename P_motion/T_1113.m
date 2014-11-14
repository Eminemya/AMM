fprintf('testing light source\n')

DD= 'data/data_1113/';
fns =dir(DD);fns(1:2)=[];

f0 = 500;
for fid=1:numel(fns)
    DD_f = [DD fns(fid).name];
    ims = dir([DD_f '/*.tif']);
    num_f = numel(ims);
    tmp_im = imread(fullfile(DD_f,ims(1).name));
    sz = size(tmp_im);
    vid = zeros([sz(1:2) num_f]);
    fprintf('1.load data\n');
    parfor i =1:num_f
        tmp = im2single(imread(fullfile(DD_f, ims(i).name)));
        vid(:,:,i) = tmp(:,:,1);
    end
    
    fprintf('2.app avg\n');
    figure(fid)    
    signal = mean(reshape(vid,[],num_f));
    subplot(211),plot(signal)
    subplot(212),tmp=U_fft(signal,f0);[~,a]=max(tmp);
    title(sprintf([fns(fid).name ': peak @ %.1f'],a/num_f*f0));
end