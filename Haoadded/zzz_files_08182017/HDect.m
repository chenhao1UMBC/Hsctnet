function [RT,RTP,alpha]=HDect(x,dict,opt)
% input x is 1018*nt matrix, testclass is a vector, like [2,3,4,9]
% output RT is the value table, RTP is the percentage table, alpha is
% sparse coefficients
    nt=opt.nt;
    testclass=opt.tg;
    feathrelen=opt.ft;% deafault is 5
    param.L=opt.T;% sparsity, default is 400
    
    resraw=cell(9,1);
    alpha=cell(9,1);
    res=zeros(9,nt);
    resP=zeros(9,nt);
    
    rNM=sum((double(x)).^2,1); % input l2 norm result
    for rr=testclass
        alpha{rr}=mexOMP(double(x),dict{rr},param);
        resraw{rr}=sum((double(x)-dict{rr}*alpha{rr}).^2,1);
        for ii=1:nt
            res(rr,ii)=mean(resraw{rr}(:,feathrelen*(ii-1)+1:feathrelen*ii));
            resP(rr,ii)=mean(resraw{rr}(:,feathrelen*(ii-1)+1:feathrelen*ii))/...
                        mean(rNM(:,feathrelen*(ii-1)+1:feathrelen*ii));
        end
    end
    Min=min(res,[],2);
    Max=max(res,[],2);
    Mean=mean(res,2);
    RT=[Min, Mean, Max] % result table

    MinP=min(resP,[],2);
    MaxP=max(resP,[],2);
    MeanP=mean(resP,2);
    RTP=[MinP, MeanP, MaxP]
end