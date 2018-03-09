% Scattering Coefficents for Mixed data

clc
clear
close all
tic

addpath(genpath('/home/chenhao/Matlab/LMData2'));
addpath(genpath('/home/chenhao/Matlab/LMSctNt'))

%%%%%%%%%%%%%%%%%%%%%%
% frequently changing parameters
%%%%%%%%%%%%%%%%%%%%%%

% input length 
N=2e7;
SNR=2000;
% mixture of class number 2(BLE),3(bt)-shown in file directory
opt.cn=[2,3,4];
% scattering network settings
fparam.Q = [2 1];
fparam.J = T_to_J(N/2,fparam);
nfiles=10; % how many files per class(pure signal)
%%%%%%%%%%%%%%%%%%%%%%

L=4e8; % per file lenght
nsamples=((L-N)/(N/2)+1)*nfiles; % samples for the mixture signal
opt.shift=N/2; % 50% overlaping
opt.nfiles=nfiles;
opt.nsamples=nsamples;
opt.parallel=1;
opt.mix=1;%%%%%%%%%%%%%%%%%%
% 'ambient','ble','bluetooth','fhss1_','fhss2_','wifi','wifi20mhz','wifi40mhz','zigbee'
% cn for the mixed signal, class name, =[1:9]
dname = 'datamix/'; % file directory
mkdir 'datamix'
for ii=1:nsamples
    datanm=['data',num2str(ii)];   
    save([dname,datanm],'nsamples'); % generate fake data for src
end
obj_func = @(file) (extract_obj_fun(file,N,1));
src = my_create_src(dname,obj_func);
% src = gtzan_src('Haoadded/haomix390_1');

fparam.filter_type = {'gabor_1d','morlet_1d'};
options.M = 2; % M layers
[Wop,fitlers] = wavelet_factory_1d(N, fparam, options);
feature_fun = {@(x)(format_scat(log_scat(renorm_scat(scat(x,Wop)))))};

db = Hprepare_database(src,feature_fun,opt,SNR);
db.cn=opt.cn;
nm1=['norm_mix',num2str(opt.cn),'db390_9classqn22_positive_renorm_snr', num2str(SNR)];
save(nm1,'db')
db2 = Hprepare_database2(src,feature_fun,opt,SNR);
nm2=['norm_mix',num2str(opt.cn),'db390_9classqn22_negative_renorm_snr', num2str(SNR)];
save(nm2,'db2')


%%%%%%%%%%%%%%%%%%
opt.cn=[2,4,9];
db = Hprepare_database(src,feature_fun,opt,SNR);
db.cn=opt.cn;
nm1=['norm_mix',num2str(opt.cn),'db390_9classqn22_positive_renorm_snr', num2str(SNR)];
save(nm1,'db')
db2 = Hprepare_database2(src,feature_fun,opt,SNR);
nm2=['norm_mix',num2str(opt.cn),'db390_9classqn22_negative_renorm_snr', num2str(SNR)];
save(nm2,'db2')
%%%%%%%%%%%%%%%%%%
opt.cn=[3,4,9];
db = Hprepare_database(src,feature_fun,opt,SNR);
db.cn=opt.cn;
nm1=['norm_mix',num2str(opt.cn),'db390_9classqn22_positive_renorm_snr', num2str(SNR)];
save(nm1,'db')
db2 = Hprepare_database2(src,feature_fun,opt,SNR);
nm2=['norm_mix',num2str(opt.cn),'db390_9classqn22_negative_renorm_snr', num2str(SNR)];
save(nm2,'db2')
%%%%%%%%%%%%%%%%%%
opt.cn=[3,4,9];
db = Hprepare_database(src,feature_fun,opt,SNR);
db.cn=opt.cn;
nm1=['norm_mix',num2str(opt.cn),'db390_9classqn22_positive_renorm_snr', num2str(SNR)];
save(nm1,'db')
db2 = Hprepare_database2(src,feature_fun,opt,SNR);
nm2=['norm_mix',num2str(opt.cn),'db390_9classqn22_negative_renorm_snr', num2str(SNR)];
save(nm2,'db2')
%%%%%%%%%%%%%%%%%%
opt.cn=[2,3,4,9];
db = Hprepare_database(src,feature_fun,opt,SNR);
db.cn=opt.cn;
nm1=['norm_mix',num2str(opt.cn),'db390_9classqn22_positive_renorm_snr', num2str(SNR)];
save(nm1,'db')
db2 = Hprepare_database2(src,feature_fun,opt,SNR);
nm2=['norm_mix',num2str(opt.cn),'db390_9classqn22_negative_renorm_snr', num2str(SNR)];
save(nm2,'db2')
