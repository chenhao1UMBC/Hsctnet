function model = Haffine_train(db,train_set,opt)
% db is P*N matrix, P dimensional, N samples
%t rain_set is n*1 indexes
% opt.dim to choose q the principal dimesions
	if nargin < 3
		opt = struct();
	end
	
	% Set default options.
	opt = fill_struct(opt,'dim',80);
	
	% Create mask to separate the training vector
    train_set=sort(train_set);
    NperClass=length(train_set)/length(db.src.classes);
    
	for k = 1:length(db.src.classes)
        
		% Determine the feature vectors corresponding to ind_obj objects.
		ind_feat =train_set((1+NperClass*(k-1)):NperClass*k);
		
		% Calculate centroid and all the principal components.
		mu{k} = sig_mean(db.features(:,ind_feat));
		v{k} = sig_pca(db.features(:,ind_feat),0);

		% Truncate principal components if they exceed the maximum dimension.
		if size(v{k},2) > max(opt.dim)
			v{k} = v{k}(:,1:max(opt.dim));
		end
	end

	% Prepare output.
	model.model_type = 'affine';
	model.dim = opt.dim;
	model.mu = mu;
	model.v = v;
end

function mu = sig_mean(x)
	% Calculate mean along second dimension.

    C = size(x,2);
    
    mu = x*ones(C,1)/C;
end


function [u,s] = sig_pca(x,M)
	% Calculate the principal components of x along the second dimension.

	if nargin > 1 && M > 0
		% If M is non-zero, calculate the first M principal components.
	    [u,s,v] = svds(x-sig_mean(x)*ones(1,size(x,2)),M);
	    s = abs(diag(s)/sqrt(size(x,2)-1)).^2;
	else
		% Otherwise, calculate all the principal components.
		[u,d] = eig(cov(x'));
		[s,ind] = sort(diag(d),'descend');
		u = u(:,ind);
    end
% save('pca.mat')
end
