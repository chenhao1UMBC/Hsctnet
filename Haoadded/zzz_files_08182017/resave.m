
clc
% clear
close all

% src = gtzan_src('..\genres');
src = gtzan_src('Haoadded/haomix390');
N = 2e7;%5*2^17

fparam.filter_type = {'gabor_1d','morlet_1d'};
fparam.Q = [8 2];
fparam.J = T_to_J(N/100,fparam);
options.M = 2;

rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,0);
SNRv=[20 10 0 -5 -10 -20 -30 -40 -50];
CorrectTable=zeros(length(SNRv));

load('db390_positive_renorm_snr20.mat')
parfor jj=1:length(SNRv)
    temp1=['db390_positive_renorm_snr',num2str(SNRv(jj))];
    nm1(jj)=load(temp1)
    temp2=['db390_negative_renorm_snr',num2str(SNRv(jj))];
    nm2(jj)=load(temp2)
end

for ii=4:length(SNRv)        
    nm3=['result_renorm_snr', num2str(SNRv(ii)),'_first'];
    load(nm3,'Ind');
    for jj=1:length(SNRv)
        db.features=[nm1(jj).db.features;nm2(jj).db2.features];
        train_opt.dim=Ind;
        % get model
        modeltest=affine_train(db, train_set, train_opt);
        % testing
        % load('model_best30')
        labels = affine_test(db, modeltest, test_set);
        % compute the error
        error = classif_err(labels, test_set, src);
        CorrectTable(ii,jj)=1-error;
        jj
    end    
    ii
end



