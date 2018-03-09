% Generate Figure 5 of the "Deep Scattering Spectrum" paper.
% modified from /home/chenhao/Matlab/LMSctNt/papers/DSS/DSS_Figure5.m
clc
clear
close all
run('addpath_scatnet.m')
mkdir('/home/chenhao/Matlab/LMData2')
addpath(genpath('/home/chenhao/Matlab/LMData2'));

tic
k=4;
N=2e6;
obj=matfile('fhss1_1');
x1=obj.('x')((1+(k-4)*N):(k-3)*N,1);   
filt_opt.filter_type = {'gabor_1d','morlet_1d'};
filt_opt.Q = [8,1];
filt_opt.J = T_to_J(N/100,filt_opt);
options.M = 2;
%{  
filt_opt.B = [8 1];
filt_opt.Q = [16 2];
filt_opt.J = T_to_J([round(length(x1)/100) round(length(x1)/100)], filt_opt);
%}

% Set inversion options. Just use defaults here.
inv_scat_opt = struct();

% Prepare first-order scattering transform.
scat_opt.M = 1;
[Wop, filters] = wavelet_factory_1d(length(x1), filt_opt, scat_opt);

% Calculate scattering and reconstruct.
S = scat(x1, Wop); 
x1t1 = Hinverse_scat(S, filters, inv_scat_opt);
save('INT_x1_2e6-81100','x1')
save('INT_x1t1_2e6-81100','x1t1')
% Prepare second-order scattering transform.
scat_opt.M = 2;
[Wop, filters] = wavelet_factory_1d(length(x1), filt_opt, scat_opt);

% Calculate scattering and reconstruct.
S = scat(x1, Wop);
x1t2 = Hinverse_scat(S, filters, inv_scat_opt);
save('INT_x1t2_2e6-81100','x1t2')
t_resol = 1000;
len_x = length(x1); % xlen
len_window = floor(len_x/t_resol);
toc

if ~exist('fs')
    fs=1e8;
end

figure
subplot(311);
spectrogram(x1,len_window,[],[],fs,'yaxis','centered')
title(['original-sepctrogram'])

subplot(312);
spectrogram(x1t1,len_window,[],[],fs,'yaxis','centered')
title(['firstlayer-reconstr-sepctrogram'])

subplot(313);
spectrogram(x1t2,len_window,[],[],fs,'yaxis','centered')
title(['2layers-reconstr-sepctrogram'])

toc




