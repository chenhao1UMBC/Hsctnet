
% SNR = 20;
% c = combnk(1:length(opt.sig_name),2);
% for ii = 1:size(c,1)
%     opt.cn = c(ii,:);
%     opt.cndb = [0, 0];
%     run savedata    
% end

% SNR = 20;
% run savedata
% 
% SNR = 0;
% run savedata
% 
% SNR = -5;
% run savedata
% 
% SNR = -10;
% run savedata
% 
% SNR = -20;
% run savedata
% 
% SNR = -30;
% run savedata

SNR = 30;
run savedata

SNR = 40;
run savedata