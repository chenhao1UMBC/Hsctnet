% new saving results

clc
clear
close all
run('addpath_scatnet.m')

% src = gtzan_src('..\genres');
src = gtzan_src('Haoadded/haomix390');
N = 2e7;%5*2^17
global G_N
SNR=-50;
G_N=N;

fparam.filter_type = {'gabor_1d','morlet_1d'};
fparam.Q = [8 2];
fparam.J = T_to_J(N/100,fparam);
options.M = 2;




%% -10
load('db390_positive_renorm_snr-10','db')

load('db390_negative_renorm_snr-10','db2')
% run('PlotCoeff')

db.features=[db.features;db2.features];

% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,0);
Dimresult=zeros(size(db.features,1),1);

nfold=5;
corrt=zeros(nfold,1);
L_c=length(src.classes);
L_vs=length(valid_set)/L_c;
L_ts=length(train_set)/L_c;
temp=zeros(4,L_vs);
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
nm=['result_renorm_snr', num2str(-10),'_first'];
save(nm,'labels', 'SNR','CVbest', 'Ind','Correct','Dimresult')

%% -20
load('db390_positive_renorm_snr-20','db')

load('db390_negative_renorm_snr-20','db2')
% run('PlotCoeff')

db.features=[db.features;db2.features];

% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,0);
Dimresult=zeros(size(db.features,1),1);

nfold=5;
corrt=zeros(nfold,1);
L_c=length(src.classes);
L_vs=length(valid_set)/L_c;
L_ts=length(train_set)/L_c;
temp=zeros(4,L_vs);
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
nm=['result_renorm_snr', num2str(-20),'_first'];
save(nm,'labels', 'SNR','CVbest', 'Ind','Correct','Dimresult')

%% -30
load('db390_positive_renorm_snr-30','db')

load('db390_negative_renorm_snr-30','db2')
% run('PlotCoeff')

db.features=[db.features;db2.features];

% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,0);
Dimresult=zeros(size(db.features,1),1);

nfold=5;
corrt=zeros(nfold,1);
L_c=length(src.classes);
L_vs=length(valid_set)/L_c;
L_ts=length(train_set)/L_c;
temp=zeros(4,L_vs);
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
nm=['result_renorm_snr', num2str(-30),'_first'];
save(nm,'labels', 'SNR','CVbest', 'Ind','Correct','Dimresult')

%% -40
load('db390_positive_renorm_snr-40','db')

load('db390_negative_renorm_snr-40','db2')
% run('PlotCoeff')

db.features=[db.features;db2.features];

% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,0);
Dimresult=zeros(size(db.features,1),1);

nfold=5;
corrt=zeros(nfold,1);
L_c=length(src.classes);
L_vs=length(valid_set)/L_c;
L_ts=length(train_set)/L_c;
temp=zeros(4,L_vs);
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
nm=['result_renorm_snr', num2str(-40),'_first'];
save(nm,'labels', 'SNR','CVbest', 'Ind','Correct','Dimresult')

%% -50
load('db390_positive_renorm_snr-50','db')

load('db390_negative_renorm_snr-50','db2')
% run('PlotCoeff')

db.features=[db.features;db2.features];

% Reset random number generator to ensure getting consisten split.
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,0);
Dimresult=zeros(size(db.features,1),1);

nfold=5;
corrt=zeros(nfold,1);
L_c=length(src.classes);
L_vs=length(valid_set)/L_c;
L_ts=length(train_set)/L_c;
temp=zeros(4,L_vs);
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
nm=['result_renorm_snr', num2str(-50),'_first'];
save(nm,'labels', 'SNR','CVbest', 'Ind','Correct','Dimresult')