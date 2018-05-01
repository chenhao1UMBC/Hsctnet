% Scattering Coefficents for Mixed data

clc
clear
close all
tic

addpath(genpath('/home/chenhao/Matlab/LMData4'));
addpath(genpath('/home/chenhao/Matlab/LMSctNt'));
run prms_mix

% load('wopfilters_qn22_N8e6.mat')
[Wop,filters] = wavelet_factory_1d(N, fparam, options);
feature_fun = {@(x)(format_scat(log_scat(renorm_scat(scat(x,Wop)))))};

%%
SNR = 2000;
run allcombinations
