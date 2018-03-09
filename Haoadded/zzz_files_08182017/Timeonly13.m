% Script to reproduce the experiments leading to the results provided in the
% Table 2 of the paper "Deep Scattering Spectrum" by J. Andén and S. Mallat.

% M=2 scattering
tic
clear
clc
close all
run('addpath_scatnet.m')
addpath(genpath('/home/chenhao/Matlab/LMData2'));

opt=struct();
src = gtzan_src('Haoadded/haomix390_9');
opt.filesnclass=[390, 9];
N = 2e7;%5*2^17
global G_N
SNR=2000;
G_N=N;

fparam.filter_type = {'gabor_1d','morlet_1d'};
fparam.Q = [2,1];
fparam.J = T_to_J(N/2,fparam);
options.M = 2;

%% scattering networkload('fitlers_q82n2e7')
% load('fitlers_q82n2e7')
% load fitlers_q21n2e7
[Wop,filters] = wavelet_factory_1d(N, fparam, options);
feature_fun = {@(x)(format_scat(log_scat(renorm_scat(scat(x,Wop)))))};
% save('fitlers_q82n2e7','filters','Wop')

%% SN output
opt.parallel=1;%<<<<------------------------------
opt.mix=0; %%%%%%%%%%%%%<<<<---------------------- if 1,gtzan_src('Haoadded/haomix390_1')
db = Hprepare_database(src,feature_fun,opt,SNR);
db.features = single(db.features);
nm1=['normdb390_9classqn22_positive_renorm_snr', num2str(SNR)];
% save(nm1,'db')
% load('db390_9class_positive_renorm_snr-50','db')

db2 = Hprepare_database2(src,feature_fun,opt,SNR);
db2.features = single(db2.features);
nm2=['normdb390_9classqn22_negative_renorm_snr', num2str(SNR)];
save(nm2,'db2')
% load('db390_9class_negative_renorm_snr-50','db2')
% run('PlotCoeff')



db.features=[db.features;db2.features];


%% Classification PCA with CV 
% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,1);
Dimresult=zeros(size(db.features,1),1);

nfold=5;
corrt=zeros(nfold,1);
L_c=length(src.classes);
L_vs=length(valid_set)/L_c;
L_ts=length(train_set)/L_c;
% Cross Validation
for jj=1:floor(size(db.features,1)/50):(size(db.features,1))
    % dimention
    train_opt.dim = jj;
    parfor ii=1:nfold       
        new_train=[];
        new_cv=[];
        % update the train_set and valid_set
        for k=1:L_c
            newset=[train_set((1+(k-1)*L_ts):k*L_ts) valid_set((1+(k-1)*L_vs):k*L_vs)];
            newset = newset(randperm(length(newset)));
            new_train=[new_train newset(1:L_ts)];
            new_cv=[new_cv newset( 1+L_ts:end)];
        end    
        % training
        modelCV = affine_train(db, new_train, train_opt);
        labelsCV = affine_test(db, modelCV, new_cv);
        errorCV = classif_err(labelsCV, new_cv, src);
        % divide training_set and cross validation    
        corrt(ii)=1-errorCV;
    end
    Dimresult(jj)=sum(corrt)/nfold;
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
nm=['result_9class_qn22renorm_snr', num2str(SNR)];
save(nm,'labels', 'SNR','CVbest', 'Ind','Correct','Dimresult','test_set')
toc



%% %%%%%%%%%% regular PCA classification
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



%% %%%%%%%%% provided
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
%}
