function feature= hdetection(db,model,test_set)
    % Classify the feature vectors separately.
    [features] =hfeature (...
            db.features(:,306*(test_set(1)-1)+1:306*test_set(end)),model.mu,model.v,model.dim);
    temp(:,:)=features(1,:,:);
    for ii = 1:size(test_set,2)
        feature(ii,:)=mean(temp(306*(ii-1)+1:306*ii,:),1);
    end
end

function  [features]= hfeature(t,mu,v,dim)
    L = length(dim);        % number of dimensions
    D = length(mu);         % number of classes
    P = size(t,2);          % number of feature vectors    
    for d = 1:D
        features(1:size(v{d},2),:,d) = happrox(t,mu{d},v{d});
    end
end

function feature = happrox(s,mu,v)
        % Subtract the class centroid.
        s = bsxfun(@minus,s,mu);

        % Prepare the feature matrix.
        feature = zeros(size(v,2),size(s,2));

        % Use Pythagoras to calculate the norm of the orthogonal projection at each
        % approximating dimension.
%       feature(1,:) = sum(abs(s).^2,1); 

        feature(1:end,:) = abs(v'*s).^2;
        feature = sqrt(cumsum(feature,1));
end                                       
