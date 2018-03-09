% this file is using the dictionay learn on scattering coefficients after PCA
% to do classificaiton and estimation

% clear
clc
close all
clearvars -except db
tic
run('addpath_scatnet.m')
src = gtzan_src('Haoadded/haomix390_9');
% load('db390_9class_positive_renorm_snr20.mat')
% load('db390_9class_negative_renorm_snr20.mat')
% db.features=[db.features;db2.features];

C=size(db.features,2);% how many columns
Nfiles=length(src.files)/length(src.classes); % is how many files per class
Ndots=size(db.features,1);% size(db.features,1) is how many rows, dot of the output
feathrelen=C/length(src.classes)/Nfiles;
Scout=zeros(Ndots*feathrelen,C/feathrelen); 
n=1; % which sample to visualize
q=221; % dimensions desired
% for 9 classes, each class 390 samples
% 390 for 'ambient','ble','bluetooth','fhss1_','fhss2_', 'wifi','wifi20mhz','wifi40mhz','zigbee'
Nclass=4;
for ii=1:Nclass
    IND=[1,2,3,8];    % ble, bluetooth, fhss_1, zigbee
    x=db.features(:,feathrelen*390*IND(ii)+1:feathrelen*390*(IND(ii)+1)); % 
    % reduce dimensions by dual pca 
    for Ind=1:390
        xr(:,Ind)=reshape(x(:,feathrelen*(Ind-1)+1:feathrelen*Ind), [],1);
    end
    xtraining=xr(:,1:350);
    xtesting(:,351:390,ii)=xr(:,351:end);
    A=(xtraining-mean(xtraining,2))'*(xtraining-mean(xtraining,2));
    [v,d{ii}]=eig(A);
    [s,ind] = sort(diag(d{ii}),'descend');
    u=(inv(sqrt(d{ii}))*v'*(xtraining-mean(xr,2))')';
    u = u(:,ind);
    vq{ii}=u(:,1:q); 
    X=vq{ii}'*xr;       
    % Training Dictionary
    % set training  parameters
%     param1.K=round(size(X,1)/4);% param.K (size of the dictionary, optional is param.D is provided)
%     param1.lambda=100;%             param.lambda  (parameter)
%     param1.mode=0;
%     param1.iter=1000;
%     [Dict{ii}, mode]=mexTrainDL(X,param1); 
end




% param2.lambda=param1.lambda;
% param2.lambda2=0;
% param2.mode=2;
% for r=1:Nclass % which class
%     for c=1:40
%         x=vq{r}'*xtesting(:,350+c,r);    
%         S{r,c}=mexLasso(x,Dict{r},param2);
%         Xin{r,c}=x;
%     end
% end
% Crrctness=HClassification(Xin,Dict,S);


% Classification
%{
% regular PCA stage -- it shows really bad performance here 25% correctness
% like flipp a coin
xpca=zeros(q,Nclass,40,Nclass);%xpca(projected data,class#,sample# in a class,
res=zeros(Nclass,40,Nclass);
results=zeros(Nclass,40);
for n=1:Nclass
    for r=1:Nclass % which class
        for c=1:40
            xpca(:,r,c,n)=vq{n}'*xtesting(:,350+c,r);    
            res(r,c,n)=norm(xpca(:,r,c,n)).^2;
        end
    end
end
for r=1:Nclass % which class
    for c=1:40 
        [value(r,c),results(r,c)]=max(res(r,c,:),[],3); %results should
        %like [1111;22222;33333;44444]
    end
end

figure
%}


% detection




 
    