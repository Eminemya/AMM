%A. fft
% demean:
for i=1:size(phase,4)
    phase(:,:,:,i)= bsxfun(@minus,phase(:,:,:,i),mean(phase(:,:,:,i),3));
end
sz=size(phase);
phase_2 = reshape(abs(fft(phase,[],3)),prod(sz(1:2)),[]);
feat = double(phase_2(ind,:));
% kill low freq:
tcen = ceil(size(feat,2)/2);
uc = U_count(feat(:,1:tcen),5,90,1.5);
count = sum(uc>0);
[a,b]=findpeaks(count,'minpeakdistance',2,'minpeakheight',prctile(count,97));
clf
plot(count)
hold on 
plot(b,a,'rx')
hold off 
%title(['gt: ' num2str(size(phase,3)*f1/fs) ' ; exp: ' num2str(b)])
%saveas(gca,['freq_' aa{aid} '_a.png'])
%save(['freq_' aa{aid} '_a'],'feat','uc')
