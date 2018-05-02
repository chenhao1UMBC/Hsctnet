% L = 2
c = combnk(1:length(opt.sig_name),2);
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 6];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [6, 0];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 10];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [10, 0];
    run savedata    
end

for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [3, 0];
    run savedata    
end

for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 3];
    run savedata    
end

for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 20];
    run savedata    
end

for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [20, 0];
    run savedata    
end

% L = 3
c = combnk(1:length(opt.sig_name),3);
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [3, 0, 3];
    run savedata    
end

for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 3, 3];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [3, 3, 0];
    run savedata    
end

for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 6, 6];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [6, 0, 6];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [6, 6, 0];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 10, 10];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [10, 0, 10];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [10, 10, 0];
    run savedata    
end

for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [20, 0, 20];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [0, 20, 20];
    run savedata    
end
for ii = 1:size(c,1)
    opt.cn = c(ii,:);
    opt.cndb = [20, 20, 0];
    run savedata    
end

%}