
clc
clear
close all
tic
run('addpath_scatnet.m')
src = gtzan_src('Haoadded/haomix390_9');
SNRv= [20, 10, 0,-5,-10,-20,-30,-40,-50];
% input SNR=ii, if SNR=20, classifier=10,0,-5,-10,-20,-30,-40,-50
load modeltest9
for ii=1:9
    clear db db2
    dbnm1=['db390_9class_positive_renorm_snr' num2str(SNRv(ii))];
    dbnm2=['db390_9class_negative_renorm_snr' num2str(SNRv(ii))];
    load(dbnm1,'db')
    load(dbnm2,'db2')
    db.features=[db.features;db2.features];y
    load sets

    % classification
    for jj=1:9       
%         PCAnm=['result_9class_renorm_snr' num2str(SNRv(ii))];
%         load(PCAnm)
%         [CVbest Ind]=max(Dimresult);
%         train_opt.dim=Ind;
%         % get model
%         modeltest{ii}=affine_train(db, train_set, train_opt);

        labels = affine_test(db, modeltest{jj}, test_set);
        % compute the error
        error = classif_err(labels, test_set, src);
        SNRTable(ii,jj)=1-error;
    end
ii
end
toc
% save('modeltest9','modeltest')
save('SNRTable9_t1','SNRTable')
figure