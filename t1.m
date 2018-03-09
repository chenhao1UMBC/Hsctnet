% start here
clc
clear
% close all
tic

% t00 = combnk(1:6,2);
t00 = [1 4; 2 5; 3 6;];
addpath(genpath('/home/chenhao/Matlab/LMData4'));
addpath(genpath('/home/chenhao/Matlab/LMSctNt'));
for iii2 = 1:size(t00, 1)   
    t0 = t00(iii2, :);
for ii1 = [1,2,4,8,16] %n
for jj1 = [1,2,4] %q

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
    opt.cn = t0(1); % Which class to mix,forLMdata[am,ble,bt,fhss1,fhss2,wifi,wifi1,wifi2,zigbee]
                    % LMdata3 [ble, bt, fhss1, shss2, wifi1 and wifi2]
    opt.cndb = [0]; % db 0db is the same magnitude
else % mixture
    opt.cn = 'non-miture'; % class notation
    opt.filesnclass = [nsamples, C];
end
fparam.Q = [1 q];
fparam.J = T_to_J(N/n,fparam);
fparam.filter_type = {'gabor_1d','morlet_1d'};

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

%%
[Wop,filters] = wavelet_factory_1d(N, fparam, options);
feature_fun = {@(x)(format_scat(log_scat(renorm_scat(scat(x,Wop)))))};
run savedata 
opt.cn = t0(2);
opt.cndb = 0;
run savedata 
opt.cn = t0;
opt.cndb = [0, 0];
run savedata 

run comparison.m
hello(ii1, jj1) = avd;


end
end
filename = ['allcombnk_qn',num2str(q), num2str(n),'_C' num2str(t0)];
save(filename,'hello')
end

