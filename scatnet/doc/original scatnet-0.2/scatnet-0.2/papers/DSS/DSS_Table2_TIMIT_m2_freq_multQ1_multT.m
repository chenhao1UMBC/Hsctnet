% M=2 scattering + freq scatt, mult Q1, mult T, cv parameters

run_name = 'DSS_Table2_TIMIT_m2_freq_multQ1_multT';

src = phone_src('/path/to/timit');

[train_set,test_set,valid_set] = phone_partition(src);

N = 2^13;
T_s = 2560;

filt1_opt.filter_type = {'gabor_1d','morlet_1d'};
filt1_opt.Q = [8 1];
filt1_opt.J = T_to_J(512,filt1_opt);

sc1_opt.M = 2;

ffilt1_opt.filter_type = 'morlet_1d';
ffilt1_opt.J = 6;

fsc1_opt.M = 1;

Wop1 = wavelet_factory_1d(N, filt1_opt, sc1_opt);
fWop1 = wavelet_factory_1d(64, ffilt1_opt, fsc1_opt); 

scatt_fun1 = @(x)(log_scat(renorm_scat(scat(x,Wop1))));
fscatt_fun1 = @(x)(func_output(@scat_freq,2,scatt_fun1(x),fWop1));
format_fun1 = @(x)(format_scat(fscatt_fun1(x)));

filt2_opt = filt1_opt;
filt2_opt.Q = [1 1];
filt2_opt.J = T_to_J(512,filt2_opt);

sc2_opt = sc1_opt;

ffilt2_opt = ffilt1_opt;
ffilt2_opt.J = 4;

fsc2_opt = fsc1_opt;

Wop2 = wavelet_factory_1d(N, filt2_opt, sc2_opt);
fWop2 = wavelet_factory_1d(16, ffilt2_opt, fsc2_opt); 

scatt_fun2 = @(x)(log_scat(renorm_scat(scat(x,Wop2))));
fscatt_fun2 = @(x)(func_output(@scat_freq,2,scatt_fun2(x),fWop2));
format_fun2 = @(x)(format_scat(fscatt_fun2(x)));

filt3_opt = filt1_opt;
filt3_opt.J = T_to_J(2*512,filt3_opt);

sc3_opt = sc1_opt;

Wop3 = wavelet_factory_1d(N, filt3_opt, sc3_opt);

scatt_fun3 = @(x)(log_scat(renorm_scat(scat(x,Wop3))));
fscatt_fun3 = @(x)(func_output(@scat_freq,2,scatt_fun3(x),fWop1));
format_fun3 = @(x)(format_scat(fscatt_fun3(x)));

filt4_opt = filt2_opt;
filt4_opt.J = T_to_J(2*512,filt4_opt);

sc4_opt = sc2_opt;

Wop4 = wavelet_factory_1d(N, filt4_opt, sc4_opt);

scatt_fun4 = @(x)(log_scat(renorm_scat(scat(x,Wop4))));
fscatt_fun4 = @(x)(func_output(@scat_freq,2,scatt_fun4(x),fWop2));
format_fun4 = @(x)(format_scat(fscatt_fun4(x)));

filt5_opt = filt1_opt;
filt5_opt.J = T_to_J(4*512,filt5_opt);

sc5_opt = sc1_opt;

Wop5 = wavelet_factory_1d(N, filt5_opt, sc5_opt);

scatt_fun5 = @(x)(log_scat(renorm_scat(scat(x,Wop5))));
fscatt_fun5 = @(x)(func_output(@scat_freq,2,scatt_fun5(x),fWop1));
format_fun5 = @(x)(format_scat(fscatt_fun5(x)));

filt6_opt = filt2_opt;
filt6_opt.J = T_to_J(4*512,filt6_opt);

sc6_opt = sc2_opt;

Wop6 = wavelet_factory_1d(N, filt6_opt, sc6_opt);

scatt_fun6 = @(x)(log_scat(renorm_scat(scat(x,Wop6))));
fscatt_fun6 = @(x)(func_output(@scat_freq,2,scatt_fun6(x),fWop2));
format_fun6 = @(x)(format_scat(fscatt_fun6(x)));

duration_fun = @(x,obj)(32*duration_feature(x,obj));

features = {format_fun1, format_fun2, format_fun3, ...
	format_fun4, format_fun5, format_fun6, duration_fun};

	for k = 1:length(features)
		fprintf('testing feature #%d...',k);
		tic;
		sz = size(features{k}(randn(N,1)));
		aa = toc;
		fprintf('OK (%.2fs) (size [%d,%d])\n',aa,sz(1),sz(2));
	end

database_opt.input_sz = N;
database_opt.output_sz = T_s;
database_opt.obj_normalize = 2;
database_opt.collapse = 1;

db = prepare_database(src,features,database_opt);
db.features = single(db.features);
db = svm_calc_kernel(db,'gaussian','triangle',[db.indices{train_set}]);

optt.kernel_type = 'gaussian';
optt.gamma = 2.^[-14:2:-10];
optt.C = 2.^[2:2:6];
optt.search_depth = 2;
optt.full_test_kernel = 1;

[dev_err_grid,C_grid,gamma_grid] = ...
	svm_adaptive_param_search(db,train_set,valid_set,optt);

[dev_err,ind] = min(dev_err_grid{end});
C = C_grid{end}(ind);
gamma = gamma_grid{end}(ind);

optt1 = optt;
optt1.C = C;
optt1.gamma = gamma;

model = svm_train(db,train_set,optt1);
labels = svm_test(db,model,test_set);
err = classif_err(labels,test_set,db.src);
			
save([run_name '.mat'],'err','C','gamma');

