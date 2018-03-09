% Script to reproduce the experiments leading to the results provided in the
% Table 2 of the paper "Deep Scattering Spectrum" by J. Andén and S. Mallat.

% M=2 scattering, frequency scattering, multiple Q1
clc
clear
close all
run('.\addpath_scatnet.m')
run_name = 'DSS_Table2_GTZAN_m2_freq_multQ1';

% src = gtzan_src('..\genres');
src = gtzan_src('.\haomix');
N = 5*2^17;
global G_N
G_N=N;

%% first layer???
% Time domain setup
filt1_opt.filter_type = {'gabor_1d','morlet_1d'};
filt1_opt.Q = [32 8];
filt1_opt.J = T_to_J(8192,filt1_opt);
sc1_opt.M = 2;

% Frequency domain setup
ffilt1_opt.filter_type = 'morlet_1d';
ffilt1_opt.J = 7;
fsc1_opt.M = 1;

% Calc Wavelet
Wop1 = wavelet_factory_1d(N, filt1_opt, sc1_opt);
fWop1 = wavelet_factory_1d(128, ffilt1_opt, fsc1_opt);

% Scattering Transform
scatt_fun1 = @(x)(log_scat(renorm_scat(scat(x,Wop1))));
fscatt_fun1 = @(x)(func_output(@scat_freq,2,scatt_fun1(x),fWop1));
feature_fun1 = @(x)(format_scat(fscatt_fun1(x)));

%% second layer???
% time domain setup
filt2_opt = filt1_opt;
filt2_opt.Q = [1 1];
filt2_opt.J = T_to_J(8192,filt2_opt);
sc2_opt = sc1_opt;

% frequency domain setup
ffilt2_opt = ffilt1_opt;
ffilt2_opt.J = 5;
fsc2_opt = fsc1_opt;

% Calc Wavelet
Wop2 = wavelet_factory_1d(N, filt2_opt, sc2_opt);
fWop2 = wavelet_factory_1d(32, ffilt2_opt, fsc2_opt);

% Scattering Transform
scatt_fun2 = @(x)(log_scat(renorm_scat(scat(x,Wop2))));
fscatt_fun2 = @(x)(func_output(@scat_freq,2,scatt_fun2(x),fWop2));
feature_fun2 = @(x)(format_scat(fscatt_fun2(x)));

%% Prepare scattering network
features = {feature_fun1, feature_fun2};

for k = 1:length(features)
    fprintf('testing feature #%d...',k);
    tic;
    sz = size(features{k}(randn(N,1)));
    aa = toc;
    fprintf('OK (%.2fs) (size [%d,%d])\n',aa,sz(1),sz(2));
end

%% scattering network 
db = haoprepare_database(src,features);

db.features = single(db.features);

%% classification
clear corrt
for ii=1:50
prop=0.8;
% split between training and testing
[train_set, test_set] = create_partition(src, prop);
% dimension of the affine pca classifier
train_opt.dim = 150;
% training
model = affine_train(db, train_set, train_opt);
% testing
labels = affine_test(db, model, test_set);
% compute the error
error = classif_err(labels, test_set, src);
corrt(ii)=1-error
end
sum(corrt)/50


db = svm_calc_kernel(db,'gaussian','square',1:2:size(db.features,2));

partitions = load('prts-gtzan.mat');
train_set = partitions.prt_train;
test_set = partitions.prt_test;

optt.kernel_type = 'gaussian';
optt.C = 2.^[0:4:8];
optt.gamma = 2.^[-16:4:-8];
optt.search_depth = 3;
optt.full_test_kernel = 1;

for k = 1:10
	[dev_err_grid,C_grid,gamma_grid] = ...
		svm_adaptive_param_search(db,train_set{k},[],optt);

	[dev_err(k),ind] = min(mean(dev_err_grid{end},2));
	C(k) = C_grid{end}(ind);
	gamma(k) = gamma_grid{end}(ind);

	optt1 = optt;
	optt1.C = C(k);
	optt1.gamma = gamma(k);

	model = svm_train(db,train_set{k},optt1);
	labels = svm_test(db,model,test_set{k});
	err(k) = classif_err(labels,test_set{k},db.src);

	fprintf('dev err = %f, test err = %f\n',dev_err(k),err(k));

	save([run_name '.mat'],'dev_err','err','C','gamma');
end



