% this file is using the dictionay learn on scattering coefficients after PCA
% to do classificaiton and estimation
% {
% clear
clearvars -except db
clc
close all

tic
run('addpath_scatnet.m')
src = gtzan_src('Haoadded/haomix390_9');
load('db390_9classqn22_negative_renorm_snr20.mat')
load('db390_9classqn22_positive_renorm_snr20.mat')
C=size(db.features,2);% how many columns
Nfiles=length(src.files)/length(src.classes); % is how many files per class
feathrelen=C/length(src.classes)/Nfiles;
for ii=Nfiles*9
    db2.features(1+(ii-1)*feathrelen:ii*feathrelen)=...
        flip(db2.features(1+(ii-1)*feathrelen:ii*feathrelen),2);
end
db.features=[db.features;db2.features];
clear db2

C=size(db.features,2);% how many columns
Nfiles=length(src.files)/length(src.classes); % is how many files per class
Ndots=size(db.features,1);% size(db.features,1) is how many rows, dot of the output
feathrelen=C/length(src.classes)/Nfiles;
Scout=zeros(Ndots*feathrelen,C/feathrelen); 
% for 9 classes, each class 390 samples
% 390 for 'ambient','ble','bluetooth','fhss1_','fhss2_', 'wifi','wifi20mhz','wifi40mhz','zigbee'
Nclass=9;
%}

rs = RandStream.getGlobalStream;
rs.reset;
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop,1);
% train_opt.dim=220;
% % get model
% modeltest=affine_train(db, train_set, train_opt);
% % testing
% % load('model_best30')
% labels = affine_test(db, modeltest, test_set);
% % compute the error
% error = classif_err(labels, test_set, src);
% Correct=1-error

% Create mask to separate the training vectors
train_mask = ismember(1:length(db.src.objects),train_set);
cv_mask=ismember(1:length(db.src.objects),valid_set);
for k = 3:length(db.src.classes)
    % Determine the objects belonging to class k.
    ind_obj = find([db.src.objects.class]==k&train_mask);
    cv_obj = find([db.src.objects.class]==k&cv_mask);
    % Determine the feature vectors corresponding to ind_obj objects.
    ind_feat = [db.indices{ind_obj}];
    ind_cv = [db.indices{cv_obj}];
    dict{k} = Hoptdict(db.features(:,ind_feat),db.features(:,ind_cv),k);
end
