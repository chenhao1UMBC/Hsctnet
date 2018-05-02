
db = Hprepare_database(src,feature_fun,opt,SNR);
db2 = Hprepare_database2(src,feature_fun,opt,SNR);

if opt.save == 1
    nm1 = ['db',num2str(nsamples),'_',num2str(C),'classq',num2str(q1), '&', num2str(n),'n',...
        num2str(n), '_positive_M',num2str(options.M),'_snr', num2str(SNR)];
    nm2 = ['db',num2str(nsamples),'_',num2str(C),'classq',num2str(q1), '&', num2str(n),'n',...
        num2str(n), '_negative_M',num2str(options.M),'_snr', num2str(SNR)];
    if opt.norm == 0
        if opt.mix
            nm1=['mix',num2str(opt.cn),nm1,'power_',num2str(opt.cndb)];
            nm2=['mix',num2str(opt.cn),nm2,'power_',num2str(opt.cndb)];
        end
    else
        if opt.mix
            nm1=['norm_mix',num2str(opt.cn),nm1,'power_',num2str(opt.cndb)];
            nm2=['norm_mix',num2str(opt.cn),nm2,'power_',num2str(opt.cndb)];
        end
    end
    save(nm1,'db')
    save(nm2,'db2')    
end