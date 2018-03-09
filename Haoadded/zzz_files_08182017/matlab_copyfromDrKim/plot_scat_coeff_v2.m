function plot_scat_coff(db,src)

C=size(db.features,2);% how many columns
Nfiles=length(src.objects)/length(src.classes); % is how many files per class
Ndots=size(db.features,1);% size(db.features,1) is how many rows, dot of the output
feathrelen=C/length(src.classes)/Nfiles;
SNout=zeros(Ndots*feathrelen,C/feathrelen); 
for ii=[1 6 11 16]    
    temp=db.features(:,(1+(ii-1)*feathrelen):ii*feathrelen);
    %layer 012
    figure
    imagesc(temp)
    colorbar
    % layer 1
        figure
    imagesc(temp(2:114,:))
    colorbar
    %layer 2
        figure
    imagesc(temp(115:end,:))
    colorbar
end