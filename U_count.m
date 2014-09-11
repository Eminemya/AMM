function out=U_count(mat,pdis,ptile,ntile)

out=[];
sz = size(mat);
x=cell(1,sz(1));
y=cell(1,sz(1));
v=cell(1,sz(1));

for i=1:sz(1)
    % naive thresholding
    thres = prctile(mat(i,:),ptile);
    [v{i},y{i}]=findpeaks(mat(i,:),'minpeakdistance',pdis);
    %[v{i},y{i}]=findpeaks(medfilt1(mat(i,:),3),'minpeakdistance',pdis);
    % remove outlier
    tmp_m = mean(v{i});tmp_v=v{i};tmp_v(tmp_v>tmp_m)=tmp_m;
    y{i}(v{i}<max(mean(tmp_v)*ntile,thres)) = [];
    v{i}(v{i}<max(mean(tmp_v)*ntile,thres)) = [];
    %{
    [v{i},y{i}]=findpeaks(medfilt1(mat(i,:),3),'minpeakdistance',pdis,'minpeakheight',thres);
    %}

    %[v{i},y{i}]=findpeaks(mat(i,:),'minpeakdistance',pdis,'minpeakheight',thres);
    %{
    % define noise distribution
    mm = sum(mat(i,:));
    cc = sz(2);
    [a,b]=sort(v{i},'descend');
    for j=b
        if a(j)>ntile*(mm-a(j))/(cc-1)
            % real signal
        else
        end
    end
    %}
    x{i}=i*ones(1,numel(v{i}));
end

out = sparse(cell2mat(x),cell2mat(y),cell2mat(v),sz(1),sz(2));
