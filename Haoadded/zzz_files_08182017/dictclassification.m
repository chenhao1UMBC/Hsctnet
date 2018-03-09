clear
close all
clc

tic
run('addpath_scatnet.m')
src = gtzan_src('Haoadded/haomix390_9');
% load('db390_9class_negative_renorm_snr20.mat')
% load('db390_9class_positive_renorm_snr20.mat')
load('db390_9classqn22_positive_renorm_snr-20')
load('db390_9classqn22_negative_renorm_snr-20')
C=size(db.features,2);% how many columns
Nfiles=length(src.files)/length(src.classes); % is how many files per class
feathrelen=C/length(src.classes)/Nfiles;
for ii=Nfiles*9
    db2.features(1+(ii-1)*feathrelen:ii*feathrelen)=...
        flip(db2.features(1+(ii-1)*feathrelen:ii*feathrelen),2);
end
db.features=[db.features;db2.features];
clear db2
load('sets')
% load('mu_qn22snr20')
load('mu0','mu')
load('dict20qn22_800_200')

mode=2;
if mode==0 % auto search
    for ii=1:round(size(dict{1},2)/50):size(dict{1},2)
        Tcv=ii*ones(1,9);
        % split between training and testing
        labelscv = dtest(db,valid_set, dict,Tcv,mu );
        errorcv= Hclassif_err(labelscv, valid_set, src);
        Correctcv(ii)=1-errorcv;
        (ii-1)/round(size(dict{1},2)/50)
    end
    [~,ind]=max(Correctcv);
    T=ind*ones(1,9);
    [labels,fiterr] = dtest(db,test_set, dict,T,mu);
    [error CFM]= Hclassif_err(labels, test_set, src);
    Correct=1-error
    figure
    toc
elseif mode==1 % see one cv only
    T=300*ones(1,9);
    [labels,fiterr] = dtest(db,valid_set, dict,T,mu );
    [error CFM]= Hclassif_err(labels, valid_set, src);
    Correct=1-error
    fiterr
    figure
    toc
else    
    T=400*ones(1,9);
    [labels,fiterr] = dtest(db,test_set, dict,T,mu );
    [error CFM]= Hclassif_err(labels, test_set, src);
    Correct=1-error
    fiterr
    figure
    toc
end

function [labels,ptbar] = dtest(db,test_set, dict, T,mu)
	% Create mask for the testing vectors.
	test_mask = ismember(1:length(db.src.objects),test_set);
	
	% Get the indices of the testing vectors.
	ind_obj = find(test_mask);
	
	% Determine the feature vector indices.
	ind_feat = [db.indices{ind_obj}];
	
	% Classify the feature vectors separately.
	[feature_labels,feature_err,ptraw] =select_class (...
		db.features(:,ind_feat),dict, T,mu);
	
	% Prepare a matrix of average appproximation errors for each object (second
	% dimension) with respect to each dimension of the approximating space (first
	% dimension) and class (third dimension)
	err = zeros(...
		[size(feature_err,1),length(ind_obj),size(feature_err,3)]);
	labels = zeros(size(feature_err,1),length(ind_obj));

	for l = 1:length(ind_obj)
		% For each object, determine the feature vectors it contains.
		ind = find(ismember(ind_feat,db.indices{ind_obj(l)}));

		% Average the approximation error across feature vectors.
		err(:,l,:) = mean(feature_err(:,ind,:),2);
        pt(l,:) = mean(ptraw(:,ind,:),2);
		% The label of the object is that of the class with the least error.
		[temp,labels(:,l)] = min(err(:,l,:),[],3);
    end
    ptsum=0;
    for ii=1:9
        ptsum=ptsum+sum(sum(pt(1+size(pt,1)/9*(ii-1):size(pt,1)/9*ii),ii));
    end
    ptbar=ptsum/size(pt,1);
end

function [d,err,pt] = select_class(t,dict, T,mu)
	dim=size(t,1);	% number of dimensions
	D = length(dict);		% number of classes
	P = size(t,2);		% number of feature vectors

	% Prepare approximation error vector. First index is the dimension of the
	% approximating affine space, second index that of the feature vectors
	% and third index is that of the approximating class.
	err = Inf*ones(dim+1,P,D);
	for d = 1:D
		% Store approximation errors for all feature vectors with class d.
		[err(1:dim+1,:,d),pt] = approx(t,dict{d}, T(d),mu{d});
	end
	
	% Only store the approximating dimensions specified in dim.
	err = err(dim+1,:,:);
	
	% Calculate the class of each feature vector as the one minimizing error.
	[temp,d] = min(err,[],3);
end

function [err,pt] = approx(s,dict, T,mu)
	% Prepare the error matrix.
    mu=mu+mean(s,2);
    s = bsxfun(@minus,s,mu);
	err = zeros(size(s,1)+1,size(s,2));
    PARAM.L=T;
    alpha=mexOMP(double(s),dict,PARAM);
	% Use Pythagoras to calculate the norm of the orthogonal projection at each
	% approximating dimension.
	err(1,:) = sum(abs(s).^2,1);    
	err(2:end,:) = -abs(dict*alpha).^2;
    pt=1-sum(-err(2:end,:),1)./err(1,:);
	err = sqrt(cumsum(err,1));    
end
