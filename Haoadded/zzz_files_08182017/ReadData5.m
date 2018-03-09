function x= ReadData5(IND)
%% for 2e6 points
k=IND;
if k<6 
    obj=matfile('Ambient1');
    x=obj.('Ambient1')((1+(k-1)*2e7):k*2e7,1);%hao  
end
if k<11  && k>5
    obj=matfile('Bluetooth1');
    x=obj.('Bt1')((1+(k-6)*2e7):(k-5)*2e7,1);%hao  
%     x=cell2mat(x);              
end
if k<16  && k>10 
    obj=matfile('wifi1');
    x=obj.('wifi1')((1+(k-11)*2e7):(k-10)*2e7,1);%hao  
%     x=cell2mat(x);               
end
if k<21  && k>15 
    obj=matfile('zigbee1');
    x=obj.('zigbee1')((1+(k-16)*2e7):(k-15)*2e7,1);%hao  
%     x=cell2mat(x);                
end
%% for 4000 points fixed pic- random
%{
k=IND;
if k<6 
    obj=matfile('Bluetooth1_2000');
    x=obj.('Bluetooth1_2000')(k,1);%hao  
    x=cell2mat(x);
end

if k<11  && k>5
    obj=matfile('zigbee1_2000');
    x=obj.('zigbee1_2000')(k-5,1);%hao  
    x=cell2mat(x);              
end

if k<16  && k>10 
    obj=matfile('wifi2_2000');
    x=obj.('wifi2_2000')(k-10,1);%hao  
    x=cell2mat(x);               
end

if k<21  && k>15 
    obj=matfile('Ambient1_2000');
    x=obj.('Ambient1_2000')(k-15,1);%hao  
    x=cell2mat(x);                
end
%}

%% for 4000 fixed pic- no random
%{
k=IND
G_N=40000;
start=0;%randi([1,399e6],1);%hao reading data from here
if k<2001 
    obj=matfile('Bluetooth1');
    x=obj.('Bt1')((1+(k-1)*G_N):k*G_N,1);%hao                
end

if k<4001 && k>2000
    if k<2996
        
        nm=['zigbee1' num2str(k-2000)];
        obj=matfile(nm);
        x=obj.('x');%hao
    else
        nm=['zigbee2' num2str(k-2995)];
        obj=matfile(nm);
        x=obj.('x');%hao
    end
end

if k<6001 && k>4000
    nm=['wifi2' num2str(k-4000)];
    obj=matfile(nm);
    x=obj.('x');%hao
end

if k>6000
    k=k-6000;
    obj=matfile('Ambient1');
    x=obj.('Ambient1')((1+(k-1)*G_N):k*G_N,1);%hao
%     while length(find(abs(x).^2>2e-5))<1500
%         start=randi([1,399e6],1);
%         x=obj.('Ambient1')(start:start+G_N-1,1);                       
%     end
end 
%}


%% for 200ms
% nm0=cell(40,1);
% nm=cell(40,1);
% for ii=1:10
%     nm0{ii}=['Ambient' num2str(ii) ];% mat file name
%     nm{ii}=['Ambient' num2str(ii) ];% variable name
% end                
% for ii=10+(1:10)
%     nm0{ii}=['Bluetooth' num2str(ii-10) ];
%     nm{ii}=['Bt' num2str(ii-10) ];
% end
% for ii=20+(1:10)
%     nm0{ii}=['wifi' num2str(ii-20) ];
%     nm{ii}=['wifi' num2str(ii-20) ];
% end
% for ii=30+(1:10)
%     nm0{ii}=['zigbee' num2str(ii-30) ];  
%     nm{ii}=['zigbee' num2str(ii-30) ];
% end  
% 
% pac=ceil(IND/39);
% obj=matfile(nm0{pac});
% seg=mod((IND-1),39);
% x=obj.(nm{pac})(1+1e7*seg:2e7+1e7*seg,1);

end      