% Scattering Coefficents for Mixed data

clc
clear
close all
tic

addpath(genpath('/home/chenhao/Matlab/LMData4'));
addpath(genpath('/home/chenhao/Matlab/LMSctNt'));
run prms

[Wop,fitlers] = wavelet_factory_1d(N, fparam, options);
feature_fun = {@(x)(format_scat(log_scat(renorm_scat(scat(x,Wop)))))};


run savedata