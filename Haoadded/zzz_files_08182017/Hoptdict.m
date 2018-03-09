function [Dict,fiterr] = Hoptdict(mtx,cv,n)
% train dictionary per time samples, not 8e5
% mtx is training matrix
% cv is cross validation matrix
mtx=double(mtx);
cv=double(cv);
[c,r]=size(cv);
fiterr=zeros(401,200);
nm=['fiterr_qn22_100_',num2str(n)];
for k=100% number of atoms
    for T=81:2:99
        PARAMS.Tdata=T;% how many atoms we choose
        PARAMS.L=PARAMS.Tdata;
        PARAMS.dictsize=k;
        PARAMS.iternum=15;
        PARAMS.initdict=mtx(:,1:k);
        PARAMS.data=mtx;
        Dict=ksvd(PARAMS); 
        s=0;
        featl=size(mtx,2)/273;
        for ii=1:size(mtx,2)/273
            A=mexOMP(cv(:,1+featl*(ii-1):featl*ii),full(Dict),PARAMS);     
            s=s+sum(sum((cv(:,1+featl*(ii-1):featl*ii)-full(Dict)*full(A)).^2))/...
                sum(sum((cv(:,1+featl*(ii-1):featl*ii)).^2));
        end
        fiterr(k,T)=s;            
    end
end
save(nm,'fiterr')

end