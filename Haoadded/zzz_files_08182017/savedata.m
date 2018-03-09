if opt.norm == 0
    db = Hprepare_database(src,feature_fun,opt,SNR);
    nm1 = ['db',num2str(nsamples),'_',num2str(C),'classqn',num2str(q),num2str(n),...
        '_positive_M',num2str(options.M),'_snr', num2str(SNR)];
    if opt.mix
        nm1=['mix',num2str(opt.cn),nm1,'power_',num2str(opt.cndb)];
    else
        nm1= nm1;
    end
    save(nm1,'db')

    db2 = Hprepare_database2(src,feature_fun,opt,SNR);
    nm2 = ['db',num2str(nsamples),'_',num2str(C),'classqn',num2str(q),num2str(n),...
        '_negative_M',num2str(options.M),'_snr', num2str(SNR)];
    if opt.mix
        nm2=['mix',num2str(opt.cn),nm2,'power_',num2str(opt.cndb)];
    else
        nm2= nm2;
    end
    save(nm2,'db2')

else
    db = Hprepare_database(src,feature_fun,opt,SNR);
    nm1 = ['db',num2str(nsamples),'_',num2str(C),'classqn',num2str(q),num2str(n),...
        '_positive_M',num2str(options.M),'_snr', num2str(SNR)];
    if opt.mix
        nm1=['norm_mix',num2str(opt.cn),nm1,'power_',num2str(opt.cndb)];
    else
        nm1=['norm_',nm1];
    end
    save(nm1,'db')

    db2 = Hprepare_database2(src,feature_fun,opt,SNR);
    nm2 = ['db',num2str(nsamples),'_',num2str(C),'classqn',num2str(q),num2str(n),...
        '_negative_M',num2str(options.M),'_snr', num2str(SNR)];
    if opt.mix
        nm2=['norm_mix',num2str(opt.cn),nm2,'power_',num2str(opt.cndb)];
    else
        nm2=['norm_',nm2];
    end
    save(nm2,'db2')
end