% detection with PCA only
% to do classificaiton and estimation

% clear
clearvars -except db
clc
close all

tic
run('addpath_scatnet.m')
src = gtzan_src('Haoadded/haomix390_9');
% load('db390_9class_positive_renorm_snr20.mat')
% load('db390_9class_negative_renorm_snr20.mat')
% db.features=[db.features;db2.features];

%% Classification
% {
rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,1);
load('result_9class_renorm_snr20')
% Test result
[CVbest Ind]=max(Dimresult);
train_opt.dim=Ind;
% get model
modeltest=affine_train(db, train_set, train_opt);
% testing
[labels,err,feature_err]= affine_test(db, modeltest, test_set);
% compute the error
error = classif_err(labels, test_set, src);
Correct=1-error
figure
%}
%% detection
tic
clear mix2 mix
% nmdb1='db390_9class_positive_renorm_snr20.mat'; % positive
% nmdb2='db390_9class_negative_renorm_snr20.mat'; % negative
nmdb1='mix2  4db390_9class_positive_renorm_snr20.mat'; % positive
nmdb2='mix2  4db390_9class_negative_renorm_snr20.mat'; % negative
mix=load(nmdb1);
mix2=load(nmdb2);
mix.db.features=[mix.db.features;mix2.db2.features];
clear mix2
% for 9 classes, each class 390 samples
% 390 for 'ambient','ble','bluetooth','fhss1_','fhss2_', 'wifi','wifi20mhz','wifi40mhz','zigbee'
nc=2; % choose if nc==2, choose ble for the non-mix case
feathrelen=306;% time downsampled length
nt=200; % if nt==100, choose firt 100 samples from the nc class, nt<=390
% feature without mixiing to see the reconstruction
tset=390*(nc-1)+[1:nt];%choose if nc==2, choose ble for the non-mix case
featurenc = hdetection(db,modeltest,tset);
% feature_test
featuret = hdetection(mix.db,modeltest,[1:nt]);


toc
figure
imagesc(mix.db.features(:,1:306)); colorbar