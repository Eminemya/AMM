function compileMFile( inM )
    dependencies = fdep(inM,'-q');
    dependencies = dependencies.fun;
    N = numel(dependencies);
    paths = cell(N,1);
    names = cell(N,1);
    for k = 1:numel(dependencies)
       [paths{k}, names{k}] = fileparts(dependencies{k});
       
    
    end    
    paths = unique(paths);
    withIPaths = cell(numel(paths)*2,1);
    for k = 1:numel(paths)
       withIPaths{2*k-1} = '-I';
       withIPaths{2*k} = paths{k};
    end
    names = unique(names);
    names
    paths
    mcc('-m', inM, names{:},withIPaths{:}); 
end

