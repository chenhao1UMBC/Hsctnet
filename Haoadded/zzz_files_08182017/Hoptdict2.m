function [Dict,fe] = Hoptdict2(mtx,param,n)
% train dictionary per time samples, not 8e5
% mtx is training matrix, p*N
% cv is cross validation matrix

% A=(mtx'-mean(mtx',1))'*(mtx'-mean(mtx',1));
% [v,d]=eig(A);
% [s,ind] = sort(diag(d),'descend');
% % u=(inv(sqrt(d))*v'*(mtx-mean(xr,2))')';
% v = v(:,ind);
% vq=v(:,1:param.q); 
% X=vq'*mtx;

mtx=double(mtx);

PARAMS.Tdata=param.T;% how many atoms we choose
PARAMS.L=PARAMS.Tdata;
PARAMS.dictsize=param.k;
PARAMS.iternum=15;
PARAMS.initdict=double(mtx(:,1:param.k)-param.mu{n});
PARAMS.data=double(mtx-param.mu{n});
[Dict,alpha]=ksvd(PARAMS);
fe=sum(sum((PARAMS.data-Dict*alpha).^2))/sum(sum((PARAMS.data).^2));

% param1.D=mtx(:,1:param.k);%round(size(X,1)/2);% param.K(size of the dictionary, optional is param.D is provided)
% param1.lambda=param.T;%  sparsity
% param1.mode=3;
% param1.iter=800;
% Dict.D=mexTrainDL(mtx,param1); 
% Dict.mu=mean(mtx,2);
end