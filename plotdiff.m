% start here
clear

addpath(genpath('/home/chenhao/Matlab/LMData4'));
addpath(genpath('/home/chenhao/Matlab/LMSctNt'));
t00 = [1 4; 2 5; 3 6;];
for iii2 = 1:size(t00, 1)   
t0 = t00(iii2, :);
for ii1 = [1,2,4,8,16]
for jj1 = [1,2,4]
%% initialize the importantss parameters
C = 6; % # of classes, if mixture is C=1
n = ii1; % number of windows
q = jj1; % how many wavelets per octav
N = 8e6; % input length, for LMdata2 N=2e7,LMdata3 N=2e6,LMdata4 N=8e6
SNR = 2000; 
nfiles = 1; % how many files per class(pure signal), for LMdata2, nfile=10
L = 18e8; % per file lenght, for LMdata2, L=4e8, LMdata3, L=5e8, LMdta4, L=18e8
nsamples = 100;%((L-N)/(N/2)+1)*nfiles; % samples for the mixture signal

% scattering network settings
opt.nsamples = nsamples; % =nsamples, or manually specify how many samples per file.
opt.shift = N/2; % 50% overlaping
opt.nfiles = nfiles;
opt.norm = 1;
options.M = 2; % M layers
opt.parallel = 1; % if parellel compute the data **********************
opt.mix = 1; % if processing the mixture data *************************
if opt.mix
    C = 1; % for mixture cases
%     opt.sig_name = {'ambient','ble','bluetooth','fhss1_','fhss2_',...
%     'wifi','wifi20mhz','wifi40mhz','zigbee'};
%     opt.sig_name = {'ble','bluetooth','fhss1_','zigbee'};
    opt.sig_name = {'ble_all', 'bt_all', 'fhss1_all', 'fhss2_all', 'wifi1_all', 'wifi2_all'};
    opt.cn = [1]; % Which class to mix,forLMdata[am,ble,bt,fhss1,fhss2,wifi,wifi1,wifi2,zigbee]
                    % LMdata3 [ble, bt, fhss1, shss2, wifi1 and wifi2]
    opt.cndb = [0]; % db 0db is the same magnitude
else % mixture
    opt.cn = 'non-miture'; % class notation
    opt.filesnclass = [nsamples, C];
end
fparam.Q = [q 1];
fparam.J = T_to_J(N/n,fparam);
fparam.filter_type = {'gabor_1d','morlet_1d'};


opt.cn = t0;
run comparison.m
hello(ii1, jj1) = avd;

% figure
% imagesc(t1)
% title(['Sx1x2\_clsss',num2str(opt.cn),'qn',s5,s6,'_100 samples'])
% 
% figure
% imagesc(t2)
% title(['Sx1+Sx2\_clsss',num2str(opt.cn),'qn',s5,s6,'_100 samples'])

end
end

hello

figure
plot(hello([1,2,4,8,16],1),'--x')
plot([1,2,4,8,16],hello([1,2,4,8,16],1),'--x')
hold on
plot([1,2,4,8,16],hello([1,2,4,8,16],2),'--x')
plot([1,2,4,8,16],hello([1,2,4,8,16],4),'--x')
xlabel n=N/windowlength(how many windows)
ylabel 'Euclidean difference of Sx1+Sx2-Sx1x2'
grid minor
grid on
legend('q=1','q=2','q=4')
title(['M=3, combination of class',num2str(opt.cn),'for first 100 samples'])
end