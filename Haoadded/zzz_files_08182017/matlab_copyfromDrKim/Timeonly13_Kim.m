% Script to reproduce the experiments leading to the results provided in the
% Table 2 of the paper "Deep Scattering Spectrum" by J. Andén and S. Mallat.

N = 2e7;
n_objs = 1;   % number of objects per class
SNR = 0;
dir_name = '/home/chenhao/Matlab/LMData2';

% specify dataset
obj_func = @(file) (extract_obj_fun(file,N,n_objs));
src = my_create_src(dir_name,obj_func);

% specify scatnet parameters
fparam.filter_type = {'gabor_1d','morlet_1d'};
fparam.Q = [8 2];
fparam.J = T_to_J(N/100,fparam);
options.M = 2;

% wavelet operator
% Wop = wavelet_factory_1d(N, fparam, options);
% feature_fun = {@(x)(format_scat(log_scat(renorm_scat(scat(x,Wop)))))};

% calculate scattering coefficients
opt=struct();
db = my_prepare_database(src,feature_fun,opt,SNR);
db.features = single(db.features);
%save('db390_positive_renorm_snr0','db')
plot_scat_coeff(db,src);

opt=struct();
opt.negative = 1;
db2 = my_prepare_database(src,feature_fun,opt,SNR);
db2.features = single(db2.features);
%save('db390_negative_renorm_snr0','db2')
plot_scat_coeff(db2,src);

db.features=[db.features;db2.features];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCA with CV
% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,0);
Dimresult=zeros(size(db.features,1),1);

% Cross Validation
clear corrt error model
for jj=1:floor(size(db.features,1)/50):(size(db.features,1))
    % dimention
    train_opt.dim = jj;
    for ii=1
    % training
    modelCV = affine_train(db, train_set, train_opt);
    labelsCV = affine_test(db, modelCV, valid_set);
    errorCV = classif_err(labelsCV, valid_set, src);
    %divide training_set and cross validation    
    corrt(ii)=1-errorCV;
    end
    Dimresult(jj)=sum(corrt);
    jj
end
% Test result
[CVbest Ind]=max(Dimresult);
train_opt.dim=Ind;
% get model
modeltest=affine_train(db, train_set, train_opt);
% testing
% load('model_best30')
labels = affine_test(db, modeltest, test_set);
% compute the error
error = classif_err(labels, test_set, src);
Correct=1-error
save('result_renorm_snr0','labels', 'SNR','CVbest', 'Ind','Correct','Dimresult')

% classification
%%%%%%%%% myself dimension too large not working
% portion=80;%100 means 100% for training, 80 percent for training
% dim=150;%principal components
% [training_set, test_set, labels]=haopartition(reform(db.features),portion);
% % PCA Training setup
% model=haoPCA(training_set,dim);
% [Error,resultPCA,labels]=PCAClassifier(model,test_set);

%%%%%%%%% kernel PCA
% clear corrt
% for ii=1:10
% portion=80;%100 means 100% for training, 80 percent for training
% dim=30;%principal components
% [training_set, test_set, labels]=haopartition(reform(db.features),portion);
% [U Sigma X]=haokernelPCA(training_set,dim);
% [Corrk,resultkPCA,labelsk]=kPCAClassifier(U, Sigma,test_set, X);
% corrt(ii)=Corrk;
% end
% sum(corrt)/10



%%%%%%%%%%%% provided
% clear corrt error
% for ii=1:10
% prop=[0.8];
% % split between training and testing
% [train_set, test_set, valid_set] = create_partition(src, prop);
% % dimension of the affine pca classifier
% train_opt.dim = 7;
% % training
% model = affine_train(db, train_set, train_opt);
% % testing
% labels = affine_test(db, model, test_set);
% % compute the error
% error = classif_err(labels, test_set, src)
% corrt(ii)=1-error
% end
% sum(corrt)/10

