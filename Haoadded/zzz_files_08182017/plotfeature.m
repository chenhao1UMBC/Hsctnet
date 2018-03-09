function plotfeature(dbin,src, whch,sn)
if nargin<4
     sn=1;
end

C=size(dbin.features,2);% how many columns
Nfiles=length(src.objects)/length(src.classes); % is how many files per class
Ndots=size(dbin.features,1);% size(db.features,1) is how many rows, dot of the output
feathrelen=C/length(src.classes)/Nfiles;

% for mixture
src.classes=1; 
feathrelen=306;

SNout=zeros(Ndots*feathrelen,C/feathrelen); 
set(0,'defaultfigurecolor','w')
nm={'Ambient','Bluetooth low energy','Bluetooth','FHSS1','FHSS2','Wifi', ...
    'Wifi20mhz','Wifi40mhz','Zigbee'};
% nm{whch}=['feature', num2str(whch)];
for ii=whch %1+(ii-1)*size(dbin.features,2)/length(src.classes) is the begging of the class
    temp=dbin.features(:,(feathrelen*(sn-1)+1+(ii-1)*size(dbin.features,2)/length(src.classes))...
        :((ii-1)*size(dbin.features,2)/length(src.classes)+feathrelen*sn));
    im=[temp(1:floor(size(temp,1)/2),:);flip(flip(temp(floor(size(temp,1)/2)+1:end,:),2),1)];
    %layer 012
    figure
    imagesc(im)
    colorbar
    title([nm{ii}, ' scattering coefficients-all'])
    xlabel('Time')
    ylabel('Nodes of scattering network')
    % layer 1
    figure  %size(db.features,1)/2==1379 for positive and negative
    imagesc([temp(2:114,:); flip(flip(temp(1381:(1381+112),:),2),1)])
    colorbar
    title( [nm{ii},' scattering coefficients-layer1'])
    xlabel('Time')
    ylabel('Nodes of scattering network')
    
% % adding awgn    
%     figure
%     imagesc(awgn(im,10,'measured'))
    
    
    
%     %layer 2
%     figure
%     imagesc([temp(115:1379,:);temp((1381+113):end,:)])
%     colorbar
%     title([nm{ii},' scattering coefficients-layer2'])
%     xlabel('Time')
%     ylabel('Nodes of scattering network')
end