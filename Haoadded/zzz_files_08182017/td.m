clear
close all
clc
tic
run('addpath_scatnet.m')
load('mu_qn22snr20')
% load('mu0','mu')
snr=20;
param.k=800;%r(k);% how many atoms of the dict
param.T=200;%(k);% the sparsity level
param.mu=mu;
dbnm1=['db390_9classqn22_positive_renorm_snr',num2str(snr)];
dbnm2=['db390_9classqn22_negative_renorm_snr',num2str(snr)];
dictnm=['dict',num2str(snr),'muqn22_',num2str(param.k),'_',num2str(param.T)];
src = gtzan_src('Haoadded/haomix390_9');
load(dbnm1)
load(dbnm2)
C=size(db.features,2);% how many columns
Nfiles=length(src.files)/length(src.classes); % is how many files per class
feathrelen=C/length(src.classes)/Nfiles;
for ii=Nfiles*9
    db2.features(1+(ii-1)*feathrelen:ii*feathrelen)=...
        flip(db2.features(1+(ii-1)*feathrelen:ii*feathrelen),2);
end
db.features=[db.features;db2.features];
clear db2
% for 9 classes, each class 390 samples
% 390 for 'ambient','ble','bluetooth','fhss1_','fhss2_', 'wifi','wifi20mhz','wifi40mhz','zigbee'
Nclass=9;
dict=cell(Nclass,1);
fe=cell(Nclass,1);
load('sets')
% Create mask to separate the training vectors
train_mask = ismember(1:length(db.src.objects),train_set);
cv_mask=ismember(1:length(db.src.objects),valid_set);
for k = 1:length(db.src.classes)
    % Determine the objects belonging to class k.
    ind_obj = find([db.src.objects.class]==k&train_mask);
    % Determine the feature vectors corresponding to ind_obj objects.
    ind_feat = [db.indices{ind_obj}];
    [dict{k},fe{k}] = Hoptdict2(db.features(:,ind_feat),param,k);
    save(dictnm,'dict','fe')
end
figure
toc