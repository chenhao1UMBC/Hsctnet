% AFFINE_TEST Calculate labels for an affine space model
%
% Usage
%    [labels, err, feature_err] = AFFINE_TEST(db, model, test_set)
%
% Input
%    db (struct): The database containing the feature vector.
%    model (struct): The affine space model obtained from affine_train.
%    test_set (int): The object indices of the testing instances.
%
% Output
%    labels (int): The assigned labels.
%    err (numeric): The average approximation error for each testing instance
%       and class pair.
%    feature_err (numeric): The approximation error for each feature vector 
%       and class pair.
%
% See also
%    AFFINE_TRAIN, AFFINE_PARAM_SEARCH

function [labels,feature_val] = Haffine_test(db,model,test_set)
	
	% Get the indices of the testing vectors.
    test_set=sort(test_set);
	labels=zeros(length(test_set),1);
    feature_val=zeros(length(test_set),1);
    
    for k=1:length(test_set)
        ind_feat =test_set(k);
        % Classify the feature vectors separately.
        [labels(k),feature_val(k)] =Hselect_class (...
            db.features(:,ind_feat),model.v);        
    end
    
end

function [label,val] = Hselect_class(t,v)
% t is p*1 vector, mu is 1*Nclass cell, in each is P*1 vector
% v is 1*Nclass cell, in each cell it is p*q vctor
lambda=zeros(length(v),1);
    for ii= 1:length(v)% for each class
       vtemp=v{ii};
      lambda(ii)=norm(vtemp'*t)^2;       
    end
    [val, label] = max(lambda);    
end
