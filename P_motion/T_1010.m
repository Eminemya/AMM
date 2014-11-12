%%
DIR=  'data_1010/';
nn = {'50Hz_1_'};

%% 
% 1. load data
for nid = 1
    data= cell(1,3);
for j=0:2
    data{j+1} = importdata([DIR nn{nid} 'a' num2str(j) '.txt']);
end
end


%%
% plot
clf,hold on
ran = 1e3:1.1e3;
cc= 'rgb';
for j=1:3
plot(data{j}(ran,1),data{j}(ran,2)/max(data{j}(:,2)),cc(j))
end

%%
nn0 = 'data_1010/';
nn={'100Hz_3_'};

nid=1;

dd=cell(1,3);
pp=cell(1,3);
for mid = 0:2
	dd{1+mid} = load([nn0 nn{nid} 'a' num2str(mid) '.txt']);
    [~,loc_peak] = findpeaks(dd{1+mid}(:,2));
    [~,loc_valley] = findpeaks(-dd{1+mid}(:,2));
	pp{1+mid} = interp1([loc_peak' loc_valley'],[ones(size(loc_peak))' -ones(size(loc_valley))'],1:size(dd{1+mid},1));
	end

cc ={'b-','r-','g-'};
% intensity
hold on
for i=1:numel(dd)
    plot(dd{i}(:,1),dd{i}(:,2),cc{i})
end
% phase
hold on
for i=1:numel(dd)
    ind = find(pp{i}==1);
    plot(ind,gradient(ind),cc{i})
end
