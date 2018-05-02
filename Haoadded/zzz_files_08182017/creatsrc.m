% make temp folder to feed src funciton

warning off
dname = 'datamix/'; % file directory
mkdir 'datamix'
for ii=1:opt.nsamples
    for jj=1:C
        datanm=['data',num2str(ii)];   
        mkdir ([dname,num2str(jj)])
        save([dname,num2str(jj),'/',datanm],'nsamples'); % generate fake data for src
    end
end
obj_func = @(file) (extract_obj_fun(file,N,1));
src = my_create_src(dname,obj_func);
rmdir 'datamix' s % remove temp folder
warning on