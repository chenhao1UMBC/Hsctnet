% This file is to initialize the importantss parameters

C = 6; % # of classes, if mixture is C=1
n = 2;
q = 1;
N = 8e6; % input length, for LMdata2 N=2e7,LMdata3 N=2e6,LMdata4 N=8e6
SNR = 20; 
nfiles = 1; % how many files per class(pure signal), for LMdata2, nfile=10
L = 18e8; % per file lenght, for LMdata2, L=4e8, LMdata3, L=5e8, LMdta4, L=18e8
nsamples = 200;%((L-N)/(N/2)+1)*nfiles; % samples for the mixture signal

% scattering network settings
opt.nsamples = nsamples; % =nsamples, or manually specify how many samples per file.
opt.shift = N/2; % 50% overlaping
opt.nfiles = nfiles;
opt.norm = 0;
options.M = 2; % M layers
opt.parallel = 1; % if parellel compute the data ********
opt.mix = 1; % if processing the mixture data ***********
if opt.mix
    C = 1; % for mixture cases
%     opt.sig_name = {'ambient','ble','bluetooth','fhss1_','fhss2_',...
%     'wifi','wifi20mhz','wifi40mhz','zigbee'};
%     opt.sig_name = {'ble','bluetooth','fhss1_','zigbee'};
    opt.sig_name = {'ble_all', 'bt_all', 'fhss1_all', 'fhss2_all', 'wifi1_all', 'wifi2_all'};
    opt.cn = [1,2]; % Which class to mix,forLMdata[am,ble,bt,fhss1,fhss2,wifi,wifi1,wifi2,zigbee]
                    % LMdata3 [ble, bt, fhss1, shss2, wifi1 and wifi2]
    opt.cndb = [0]; % db 0db is the same magnitude
else % mixture
    opt.cn = 'non-miture'; % class notation
    opt.filesnclass = [nsamples, C];
end
fparam.Q = [q 1];
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