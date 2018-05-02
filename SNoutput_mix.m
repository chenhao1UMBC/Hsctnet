% Scattering Coefficents for Mixed data

clc
clear
close all


addpath(genpath('/home/chenhao/Matlab/LMData4'));
addpath(genpath('/home/chenhao/Matlab/LMSctNt'));
run prms_mix

load('wopfilters_q16&0.05n2_N8e6.mat')
% [Wop,filters] = wavelet_factory_1d(N, fparam, options);
feature_fun{1} = {@(x)(format_scat(log_scat(renorm_scat(scat(x,Wop)))))};
feature_fun{2} = {@(x)(format_scat(log_scat(scat(x,Wop))))};
feature_fun{3} = {@(x)(format_scat(renorm_scat(scat(x,Wop))))};
feature_fun{4} = {@(x)(format_scat(scat(x,Wop)))};
%%

run savedata
% run allcombinations
