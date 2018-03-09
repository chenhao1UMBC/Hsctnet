% clear corrt
function [Correct Dimresult]=PCAwithCV(src,db)
prop=[0.7 0.15 0.15];
% split between training and testing
[train_set, test_set, valid_set] = Hcreate_partition(src, prop, 0);%shuffle =0, not shuffle


C=size(db.features,2);% how many columns
Nfiles=length(src.files)/length(src.classes); % is how many files per class
Ndots=size(db.features,1);% size(db.features,1) is how many rows, dot of the output
feathrelen=C/length(src.classes)/Nfiles;
SNout=zeros(Ndots*feathrelen,C/feathrelen); 
for ii=1:C/feathrelen    
    temp=db.features(:,(1+(ii-1)*feathrelen):ii*feathrelen);
    SNout(:,ii)=reshape(temp',[],1);
end
db.features=SNout;

% Cross Validation
Dimresult=zeros(size(db.features,1),1);
clear corrt error model
for jj=1:(size(Dimresult,1)/50):size(Dimresult,1)
    % dimention
    train_opt.dim = jj;
    % training
    modelCV = Haffine_train(db, train_set, train_opt);
    labelsCV = Haffine_test(db, modelCV, valid_set);
    errorCV = Hclassif_err(labelsCV, valid_set, src);
    %divide training_set and cross validation    
    Dimresult(jj)=1-errorCV;    
    jj
end

% Test result
[CVbest Ind]=max(Dimresult);
train_opt.dim=Ind;
% get model
modeltest=affine_train(db, train_set, train_opt);
% testing
labels = affine_test(db, modeltest, test_set);
% compute the error
error = classif_err(labels, test_set, src);
Correct=1-error

end