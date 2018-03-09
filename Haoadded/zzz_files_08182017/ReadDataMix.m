function x= ReadDataMix(IND,opt)
% IND is integer

sig_name = opt.sig_name;
rng(2)
P = randperm(449);
NewIND = P(IND);

if  strcmp(sig_name{1},'ble')
    pac=ceil(NewIND/(opt.nsamples/opt.nfiles)); 
    cnl=length(opt.cn);
    dbvalue=opt.cndb;
    seg=mod((NewIND-1),(opt.nsamples/opt.nfiles));
    x=zeros(opt.shift*2,1);
    for ii=1:cnl
        obj=matfile([sig_name{opt.cn(ii)},num2str(pac)]);
        temp=obj.('x')(1+opt.shift*seg:opt.shift*2+opt.shift*seg,1);
        if opt.norm ==1
            x=x+10^(dbvalue(ii)/20)*temp/norm(temp);
        else
            x = x + temp;
        end
    end
end

if strcmp(sig_name{1},'ble_all')
    cnl=length(opt.cn);
    dbvalue=opt.cndb;
    seg=mod((NewIND-1),(opt.nsamples/opt.nfiles));
    x=zeros(opt.shift*2,1);

    for ii=1:cnl
        obj=matfile([sig_name{opt.cn(ii)}]);
        temp=obj.('x')(1+opt.shift*seg:opt.shift*2+opt.shift*seg,1);
        if opt.norm == 1
            x=x+10^(dbvalue(ii)/20)*temp/norm(temp);
        else
            x = x + temp;
        end
    end
    
end

end