function [Crrctness,DF]=HClassification(X,Dict,Sparse)
% input X is cell C*N, each one is P*1 vector
%       Dict is cell array, column
%       Sparse is cell C*N, in the cell is k*1 vector
N=size(X,2);% total samples should be 1500= 10*1000*0.15
C=size(Dict,2); % classes, 10 for 10 digits
DF=zeros(C,C,N);
for r=1:C % for each dictionary
    for ii=1:C % for each class
        for jj=1:N% how many samplings
            DF(r,ii,jj)=norm(X{ii,jj}-Dict{r}*full(Sparse{ii,jj})).^2/norm(X{ii,jj})^2;
        end
    end
end
% pick min
Ind=zeros(C,N);
for ii=1:C % for each dictionary
    for jj=1:N% how many samplings
        [~, Ind(ii,jj)]=min(DF(:,ii,jj));
    end
end

Truth=[];
for ii=1:C
    Truth =[Truth; ii*ones(1,N)];
end

Crrctness=1-length(find(Ind-Truth))/C/N;

end% end of fucntion