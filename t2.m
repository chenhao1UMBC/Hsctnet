
c = combnk(1:length(opt.sig_name),2);
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 0];
    run savedata    
end

c = combnk(1:length(opt.sig_name),3);
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 0, 0];
    run savedata    
end