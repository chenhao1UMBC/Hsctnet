% scenario1_detection calc from scenario1.m
tic
clc
run('addpath_scatnet.m')
src = gtzan_src('Haoadded/haomix390_9');
if ~exist('vq')
    load('sX,xcv,xtesting,vq,Nclass600SNR2000.mat')
end
if ~exist('Dict')
    clear Dict Dictksvd
    [Dict,param2]=optdict(X,xcv,xtesting,vq,Nclass);% Training Dictionary
end

clear mix2 mix redis reper Soksvd Soksvd2
% for 9 classes, each class 390 samples
% 390 for 'ambient','ble','bluetooth','fhss1_','fhss2_', 'wifi','wifi20mhz',
%'wifi40mhz','zigbee'
nc=2; % choose if nc==2, choose ble for the non-mix case
feathrelen=306;% time downsampled length
nt=100; % if nt==100, choose firt 100 samples from the nc class, nt<=390
nmdb1='db390_9class_positive_renorm_snr20.mat'; % positive
nmdb2='db390_9class_negative_renorm_snr20.mat'; % negative
% nmdb1='mix2  3  4db390_9class_positive_renorm_snr20.mat'; % positive
% nmdb2='mix2  3  4db390_9class_negative_renorm_snr20.mat'; % negative
obj1=matfile(nmdb1);
obj2=matfile(nmdb2);
tp=obj1.db;
tp2=obj2.db2;
if nmdb1(1:3)=='mix'
    mix=tp.features(:,1:feathrelen*390);
    mix2=tp2.features(:,1:feathrelen*390);
else % not mix
    mix=tp.features(:,feathrelen*(nc-1)*390+1:feathrelen*(nc-1)*390+feathrelen*390);
    mix2=tp2.features(:,feathrelen*(nc-1)*390+1:feathrelen*(nc-1)*390+feathrelen*390);
end
mix=[mix;mix2];
clear tp tp2
xxr=zeros(size(mix,1)*feathrelen,nt);
for Ind=1:nt
    xxr(:,Ind)=reshape(mix(:,feathrelen*(Ind-1)+1:feathrelen*Ind), [],1);
end    
Soksvd=cell(Nclass,nt);% 100 samples for testing
xin=vq'*xxr;



for r=1:Nclass
    xbar(:,r)=mean(X(:,350*(r-1)+1:350*r),2);
end

for ii=1:nt
    for r=1:Nclass
        Soksvd{r,ii}=mexOMP(xin(:,ii),full(Dict{r}),param2);
        reper(r,ii)=per(xin(:,ii),Dict{r},Soksvd{r,ii});
        redis(r,ii)=dis(xin(:,ii),Dict{r},Soksvd{r,ii});
        if r==1 && per(xin(:,ii),Dict{1},Soksvd{1,ii})<0.15
            xnew=xin(:,ii)-Dict{r}*Soksvd{r,ii};
            plot(xnew)
            for rr=2:4
                Soksvd2{rr,ii}=mexOMP(xnew,full(Dict{rr}),param2);
                reperD(rr,ii)=per(xnew,Dict{rr},Soksvd2{rr,ii});
                redisD(rr,ii)=dis(xnew,Dict{rr},Soksvd2{rr,ii});
            end

        end
    end
end
showinput(X,xin,0)% plot the input, 0 means not to show
figure
imagesc(mix(:,1:306)); colorbar


function reper=per(xin, Dictksvd,Soksvd)

reper=norm(xin-Dictksvd*Soksvd)^2/norm(xin)^2;

end

function redis=dis(xin, Dictksvd,Soksvd)

redis=norm(xin-Dictksvd*Soksvd)^2;

end

function showinput(X,xin,ifshow)
if ifshow~=0
    figure
    imagesc(xin)
    colorbar
    
    figure
    imagesc(X(:,1:350))
    colorbar

    figure
    imagesc(X(:,351:2*350))
    colorbar

    figure
    imagesc(X(:,350*2+1:3*350))
    colorbar

    figure
    imagesc(X(:,350*3+1:4*350))
    colorbar

end
end
