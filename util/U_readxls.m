function y = U_readxls(name,pre)
if ~exist('pre','var')
    pre=0;
end
[~,sheetname] = xlsfinfo(name); 
y= cell(size(sheetname));
for i=1:numel(sheetname)
    y{i} = xlsread(name,sheetname{i});
    if(pre)
        % remove header
        y{i} = y{i}(find(y{i}(:,1)==0,1,'first'):end,:);
    end
end