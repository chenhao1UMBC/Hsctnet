
db = Hprepare_database(src,feature_fun,opt,SNR);
db2 = Hprepare_database2(src,feature_fun,opt,SNR);

if opt.save == 1

    if opt.norm == 0
        if opt.mix
            nm1=['mix',num2str(opt.cn),nm1,'power_',num2str(opt.cndb), '.mat'];
            nm2=['mix',num2str(opt.cn),nm2,'power_',num2str(opt.cndb), '.mat'];
        end
        nm1 = ['db',num2str(nsamples),'_',num2str(C),'classq',num2str(q1), '&', num2str(q2),'n',...
            num2str(n), '_positive_M',num2str(options.M),'_snr', num2str(SNR), '.mat'];
        nm2 = ['db',num2str(nsamples),'_',num2str(C),'classq',num2str(q1), '&', num2str(q2),'n',...
            num2str(n), '_negative_M',num2str(options.M),'_snr', num2str(SNR), '.mat'];
    else
        nm1 = ['norm_db',num2str(nsamples),'_',num2str(C),'classq',num2str(q1), '&', num2str(q2),'n',...
            num2str(n), '_positive_M',num2str(options.M),'_snr', num2str(SNR), '.mat'];
        nm2 = ['norm_db',num2str(nsamples),'_',num2str(C),'classq',num2str(q1), '&', num2str(q2),'n',...
            num2str(n), '_negative_M',num2str(options.M),'_snr', num2str(SNR), '.mat'];
        if opt.mix
            nm1=['norm_mix',num2str(opt.cn),nm1,'power_',num2str(opt.cndb), '.mat'];
            nm2=['norm_mix',num2str(opt.cn),nm2,'power_',num2str(opt.cndb), '.mat'];
        end
    end
    save(nm1,'db')
    save(nm2,'db2')    
end