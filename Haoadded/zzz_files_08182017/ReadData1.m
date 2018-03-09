function x= ReadData1(IND)
%% for 2e7 points
k=IND;
N=2e7;

if k==1 
    obj=matfile('Ambient1');
    x=obj.('Ambient1')((1+(k-1)*N):k*N,1);%hao  
end
if k==2
    obj=matfile('Bluetooth1');
    x=obj.('Bt1')((1+(k-2)*N):(k-1)*N,1);%hao  
%     x=cell2mat(x);              
end
if k==3 
    obj=matfile('wifi1');
    x=obj.('wifi1')((1+(k-3)*N):(k-2)*N,1);%hao  
%     x=cell2mat(x);               
end
if k==4 
    obj=matfile('zigbee1');
    x=obj.('zigbee1')((1+(k-4)*N):(k-3)*N,1);%hao  
%     x=cell2mat(x);                
end

end      