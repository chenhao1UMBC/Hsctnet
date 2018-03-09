% scenario1_detection calc from scenario1.m
tic
clc
close all
clear
run('addpath_scatnet.m')
src = gtzan_src('Haoadded/haomix390_9');
load('dict20qn22_800_200')

clear mix2 mix redis reper Soksvd Soksvd2
% for 9 classes, each class 390 samples
% 390 for 'ambient','ble','bluetooth','fhss1_','fhss2_', 'wifi','wifi20mhz',
%'wifi40mhz','zigbee'
nc=4; % choose if nc==2, choose ble for the non-mix case
feathrelen=5;% time downsampled length
nt=100; % if nt==100, choose last 100 samples from the nc class, nt<=390
nmdb1='db390_9classqn22_positive_renorm_snr20.mat'; % positive
nmdb2='db390_9classqn22_negative_renorm_snr20.mat'; % negative
% nmdb1='mix4  9db390_9classqn22_positive_renorm_snr20.mat'; % positive
% nmdb2='mix4  9db390_9classqn22_negative_renorm_snr20.mat'; % negative
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
xcv=mix(:,end-feathrelen*nt+1:end);% last nt samples
opt.nt=nt;
opt.ft=feathrelen;
opt.T=400;
opt.tg=[2,3,4,9];
[RT,RTP,alpha]=HDect(xcv,dict,opt);

if RTP(2)<0.01 % BLE existing
    opt.tg=[3,4,9];
    xxcv=xcv-dict{2}*alpha{2};
    [RT2,RTP2]=HDect(xcv,dict,opt);
else % BLE not existing
    if RTP(4)<0.004 % F1 existing
        opt.tg=[3,9];
        xxcv=xcv-dict{4}*alpha{4};
        [RT4,RTP4]=HDect(xcv,dict,opt);    
    end

end

toc
figure




