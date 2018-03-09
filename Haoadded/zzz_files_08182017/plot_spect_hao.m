
clear
% close all

mkdir('LMData2')
addpath(genpath('LMData2'));

smp_len = 2e6; % 200ms
k = 6; %k==1,which means first 200ms samples <20
sig_name1={'ble3'};
sig_name2={'bluetooth1'};

% sig_name={'ambient1','ble1','bluetooth1','fhss1_1','fhss2_1','iso1',...
%     'wifi1','wifi20mhz1','wifi40mhz1','zigbee1'};
for ii=1:length(sig_name1)
    obj1=matfile(sig_name1{ii});
    x1=obj1.('x')(((1+(k-1)*smp_len):k*smp_len),1);
    
%     obj2=matfile(sig_name2{ii});
%     x2=obj2.('x')(((1+(k-1)*smp_len):k*smp_len),1);
    x2=0;

    xin=x1+x2;
%     xin=circshift(xin,1e6);
    figure
    spect_v2(xin);
%     title([sig_name{ii},'-sepctrogram'])
end

% h = get(0,'children');
% for i=1:length(h)
%   saveas(h(i), ['figure' num2str(i)], 'fig');
% end
