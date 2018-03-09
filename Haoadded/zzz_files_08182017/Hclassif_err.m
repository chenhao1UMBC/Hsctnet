% CLASSIF_ERR Calculates the classification error.
%
% Usage
%    err = CLASSIF_ERR(labels, test_set, src)
%
% Input
%    labels (int): The predicted labels corresponding to the testing in-
%       stances.
%    test_set (int): The object indices of the testing instances.
%    src (struct): The source from which the objects were taken.
%
% Output
%    err (numeric): The classification error.
%
% See also
%    AFFINE_TEST, SVM_TEST

function [err, CFM]= Hclassif_err(labels,test_set,src)
	truth = [src.objects(test_set).class];

	if isfield(src,'cluster')
		cluster = src.cluster;
	else
		cluster = 1:max(truth);
	end
	
	err = 1-sum(bsxfun(@eq,cluster(labels),cluster(truth)),2)/length(truth);
    
    
    Ind0=(reshape(labels,length(test_set)/9,[]))';
    for jj=1:9
        for ii=1:9
            CFM(jj,ii)=length(find(Ind0(jj,:)==ii))/length(Ind0(jj,:));
        end
    end
end
