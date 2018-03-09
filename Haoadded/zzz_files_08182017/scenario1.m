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
% load('db390_9class_positive_renorm_snr2000.mat')
% load('db390_9class_negative_renorm_snr2000.mat')
% db.features=[db.features;db2.features];

C=size(db.features,2);% how many columns
Nfiles=length(src.files)/length(src.classes); % is how many files per class
Ndots=size(db.features,1);% size(db.features,1) is how many rows, dot of the output
feathrelen=C/length(src.classes)/Nfiles;
Scout=zeros(Ndots*feathrelen,C/feathrelen); 
n=1; % which sample to visualize
q=600; % dimensions desired -check plot(s,'x')
% for 9 classes, each class 390 samples
% 390 for 'ambient','ble','bluetooth','fhss1_','fhss2_', 'wifi','wifi20mhz','wifi40mhz','zigbee'
Nclass=8;
x=zeros(size(db.features,1),feathrelen*390*Nclass);
xr=zeros(size(db.features,1)*feathrelen,390*Nclass);
for ii=1:Nclass
    IND=2:9;%   [2,3,4,9];% ble, bluetooth, fhss_1, zigbee
    x(:,feathrelen*390*(ii-1)+1:feathrelen*390*ii)=...
    db.features(:,feathrelen*390*(IND(ii)-1)+1:feathrelen*390*IND(ii)); % 
end
    % reduce dimensions by dual pca 
for Ind=1:390*Nclass
    xr(:,Ind)=reshape(x(:,feathrelen*(Ind-1)+1:feathrelen*Ind), [],1);
end
xtraining=zeros(size(db.features,1)*feathrelen,350*Nclass);
xcv=zeros(size(db.features,1)*feathrelen,50,Nclass);
xtesting=zeros(size(db.features,1)*feathrelen,40,Nclass);
for ii=1:Nclass % first 350 for training
    xtraining(:,350*(ii-1)+1:350*(ii-1)+350)=xr(:,390*(ii-1)+1:390*(ii-1)+350);
    xcv(:,1:50,ii)=xr(:,390*(ii-1)+301:390*(ii-1)+350);
    xtesting(:,1:40,ii)=xr(:,390*(ii-1)+351:390*(ii-1)+390);
end

A=(xtraining-mean(xtraining,2))'*(xtraining-mean(xtraining,2));
[v,d]=eig(A);
[s,ind] = sort(diag(d),'descend');
u=(inv(sqrt(d))*v'*(xtraining-mean(xr,2))')';
u = u(:,ind);
vq=u(:,1:q); 
X=vq'*xtraining;   
toc
figure
% save('9sX,xcv,xtesting,vq,Nclass300SNR2000','s','X','xcv','xtesting','vq','Nclass')

[Dict,param2]=optdict(X,xcv,xtesting,vq,Nclass)
toc

%% detection

% {
% clearvars -except db Dict feathrelen vq Nclass param2
clear db2 mix
% load('mix2  3db390_9class_negative_renorm_snr20');
% mix=load('mix2  3db390_9class_positive_renorm_snr20');
load('mix2  4  9db390_9class_negative_renorm_snr20');
mix=load('mix2  4  9db390_9class_positive_renorm_snr20');
mix.db.features=[mix.db.features;db2.features];
xxr=zeros(size(mix.db.features,1)*feathrelen,390);
for Ind=1:390
    xxr(:,Ind)=reshape(mix.db.features(:,feathrelen*(Ind-1)+1:feathrelen*Ind), [],1);
end
So=cell(Nclass,100);% 100 samples for testing
xin=vq'*xxr(:,1:100);
for ii=1:100
    for r=1:Nclass
        So{r,ii}=mexLasso(xin(:,ii),Dict{r},param2);
        results(r,ii)=norm(xin(:,ii)-Dict{r}*So{r,ii})^2;
    end
end

toc
figure
imagesc(mix.db.features(:,1:306)); colorbar
%}    