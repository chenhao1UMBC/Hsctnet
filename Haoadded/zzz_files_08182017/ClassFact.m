% generate a table
CF=eye(length(src.classes));
ClassTotal=(length(labels)/length(src.classes));
% Truth = [src.objects(test_set).class];
for jj=1:length(src.classes)
    for ii=1:length(src.classes)
        CF(jj,ii)=length(find(labels((1+ClassTotal*(jj-1)):ClassTotal*jj)==ii))
    end
end
['     am','    bt', '   wf', '   zg']