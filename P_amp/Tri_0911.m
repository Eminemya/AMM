do_id =1;
switch do_id
    case 1
        % 3100 Hz, different amplitude
        f0 = 11019;
        f1 = 3100;
        fns=cell(1,3);
        suf = {'_s','_m','_l'};
        for i=1:numel(suf);fns{i} = sprintf('%dHz_%dfps%s_dl.mat',f1,f0,suf{i});end
        fns_id = 1:2;
        fr=5;
        PA=@phaseAmplify;
        aas=cell(1,numel(fns));
        aas{1}=[300 3000 0 1000 500];
        aas{2}=[300 2000 0 1000 500];
        aas{3}=[300 1000 0 1000 500];
        fids=1;
        tt=[1 inf];
        pyrType='octave';filt_level = 0;mids=0;srs=1;
        % fps
end




for fn_id=fns_id
    nn = fns{fn_id};
    for mid=mids
        for sr=srs
            for fid=fids
                alpha = aas{fn_id}(fid+1);
                do_struct_0501_p
            end
        end
    end
end
