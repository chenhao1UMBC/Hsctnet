% optimize dictionary

function [Dict,param2]=optdict(X,xcv,xtesting,vq,Nclass)
tic
% % Training Dictionary
% Dict=cell(1,Nclass);
for k=1:40% number of atoms
    for T=1:k
        param1.K=k;%round(size(X,1)/2);% param.K(size of the dictionary, optional is param.D is provided)
        param1.lambda=150;%  param.lambda  (parameter)
        param1.mode=0;
        param1.iter=800;
        % for ii=1:Nclass
        %     Dict{ii}=mexTrainDL(X(:,1+(ii-1)*350:300+(ii-1)*350),param1); 
        % end

        % Training Dictionary ksvd
        PARAMS.Tdata=T;% how many atoms we choose
        PARAMS.dictsize=k;
        PARAMS.iternum=10;
        Dict=cell(1,Nclass);
        for ii=1:Nclass
            PARAMS.initdict=X(:,1+(ii-1)*350:k+(ii-1)*350);
            PARAMS.data=X(:,1+(ii-1)*350:300+(ii-1)*350);
        %     PARAMS.data=awgn(X(:,1+(ii-1)*350:300+(ii-1)*350), 20,'measured');
            [Dict{ii},gamma{ii}]=ksvd(PARAMS); 
        end

        %% Cross validation ksvd using OMP
        param2.lambda=param1.lambda;
        param2.L=PARAMS.Tdata;
        param2.gamma=gamma;
        for r=1:Nclass % which class
            for c=1:50   
                x1cvksvd1=vq'*xcv(:,c,r); 
%                 x1cvksvd1=awgn(x1cvksvd,10,'measured');
                for ii=1:Nclass % all dictionaries
                    Scvksvd{r,c}{ii}=mexOMP(x1cvksvd1,full(Dict{ii}),param2);
                    Xincvksvd{r,c}=x1cvksvd1;
                end
            end
        end
        param2.Scv=Scvksvd;
        % classification
        for r=1:Nclass % which class
            for c=1:50   
                for ii=1:Nclass % all dictionaries
                    DF(ii,r,c)=norm(Xincvksvd{r,c}-full(Dict{ii})*...
                        Scvksvd{r,c}{ii})^2/norm(Xincvksvd{r,c})^2;
                end
            end
        end

        N=size(Xincvksvd,2);% total samples should be 1500= 10*1000*0.15
        C=size(Dict,2); % classes, 10 for 10 digits
        Ind=zeros(C,N);
        for ii=1:C % for each class
            for jj=1:N% how many samplings
                [~, Ind(ii,jj)]=min(DF(:,ii,jj));
            end
        end

        Truth=[];
        for ii=1:C
            Truth =[Truth; ii*ones(1,N)];
        end

        Crrctcv=1-length(find(Ind-Truth))/C/N
        tbl(k,T)=Crrctcv;
        save('9tbl','tbl')
        k
        T
    end
end
toc
%% testing

for r=1:Nclass % which class
    for c=1:40   
        x1=vq'*xtesting(:,c,r); 
        for ii=1:Nclass % all dictionaries
            Scvksvd{r,c}{ii}=mexOMP(x1,full(Dict{ii}),param2);
            Xin{r,c}=x1;
        end
    end
end

% classification
for r=1:Nclass % which class
    for c=1:40   
        for ii=1:Nclass % all dictionaries
            DF(ii,r,c)=norm(Xin{r,c}-full(Dict{ii})*...
                Scvksvd{r,c}{ii})^2/norm(Xin{r,c})^2;
        end
    end
end

N=size(Xin,2);% total samples should be 1500= 10*1000*0.15
C=size(Dict,2); % classes, 10 for 10 digits
Ind0=zeros(C,N);
for ii=1:C % for each class
    for jj=1:N% how many samplings
        [~, Ind0(ii,jj)]=min(DF(:,ii,jj));
    end
end

Truth=[];
for ii=1:C
    Truth =[Truth; ii*ones(1,N)];
end

Crrcttest=1-length(find(Ind0-Truth))/C/N
end