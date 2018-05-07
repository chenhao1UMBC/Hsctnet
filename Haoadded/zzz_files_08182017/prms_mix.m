% This file is to initialize the importantss parameters

C = 6; % # of classes, if mixture is C=1
n = 2;
q1 = 16; % first layer Q
q2 = 0.05; % second layer Q
N = 8e6; % input length, for LMdata2 N=2e7,LMdata3 N=2e6,LMdata4 N=8e6
SNR = 2000; 
nfiles = 1; % how many files per class(pure signal), for LMdata2, nfile=10
L = 18e8; % per file lenght, for LMdata2, L=4e8, LMdata3, L=5e8, LMdta4, L=18e8
nsamples = ((L-N)/(N/2)+1)*nfiles; % samples for the mixture signal
nmixsamples = 200; % specific number for mix sginal

% scattering network settings
opt.nsamples = nmixsamples; % =nsamples, or manually specify how many samples per file.
opt.shift = N/2; % 50% overlaping
opt.nfiles = nfiles;
opt.norm = 1; % normalize data or not, 0 means not normalize data
options.M = 2; % M layers
opt.parallel = 1; % if parellel compute the data ********
opt.mix = 1; % if processing the mixture data ***********
opt.save = 1; % save the result or not
%     opt.sig_name = {'ambient','ble','bluetooth','fhss1_','fhss2_',...
%     'wifi','wifi20mhz','wifi40mhz','zigbee'};
%     opt.sig_name = {'ble','bluetooth','fhss1_','zigbee'};
opt.sig_name = {'ble_all', 'bt_all', 'fhss1_all', 'fhss2_all', 'wifi1_all', 'wifi2_all'};

if opt.mix
    C = 1; % for mixture cases
    opt.cn = [1, 3]; % Which class to mix,forLMdata[am,ble,bt,fhss1,fhss2,wifi,wifi1,wifi2,zigbee]
                    % LMdata3 [ble, bt, fhss1, shss2, wifi1 and wifi2]
    opt.cndb = [0, 0]; % db 0db is the same magnitude
else % mixture
    opt.cn = 'non-miture'; % class notation
    opt.filesnclass = [nsamples, C];
end
fparam.Q = [q1 q2];
fparam.J = T_to_J(N/n,fparam);
fparam.filter_type = {'gabor_1d','morlet_1d'};

% make temp folder to feed src funciton
run creatsrc
