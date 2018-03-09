% coding with matlab
% By Hao Chen, May 28 2017

% feature leangth featlen is output as 2-D matrix; featlen=featCol.*featRow;
% Column is time samples, and Row is frequency lambda1&lambda2 combinations
% because the lambda2 should be smaller than lambda1, featRow is not 1+n+n.^2
% because of downsampling, the featCol is not N/Wnum; for a certain range Wnum,featCol is the same
% it means solve featlen with math calc is hard, and visualized it to check the results
% Q is important for featRow; Wnum is important forfeatCol

% input length N=2e7;
% wavelets per octave Q=1:200
% reciprocal bandwidth B=Q
% window size N/Wnum; Window numbers, Wnum=10:10:2001
% just run calc_dim.m to get the result


clear
clc

N=2e6;
for Wnum=2:10:100    
    T=round(N/Wnum);
    for Q=1:20
        B=Q;
        sigma0 = 2/sqrt(3);
        phi_bw_multiplier=1+(Q==1);
        sigma_psi=1/2*sigma0/(1-2^(-1/B));
        sigma_phi=sigma_psi/phi_bw_multiplier;
        P=round((2^(-1/Q)-1/4*sigma0/sigma_phi)/ (1-2^(-1/Q)));
        
        % feature colums
        x_resolution=0;
        oversampling=1;
        j0 = x_resolution;
        opt.Q=Q;
        J=T_to_J(T,opt);
        sigma_phi0 = sigma_phi * 2^((J-1)/Q);
        phi_bw = pi/2 * sigma0./sigma_phi0;
        ds = round(log2(2*pi/phi_bw)) - j0 -oversampling;
        ds = max(ds, 0);
        res=ds;
        featCol(Wnum,Q)=1+floor(N/(2.^res));
        
        % calc node length
%         load('filters.mat')
        xi_psi=1/2*(2^(-1/Q)+1)*pi;
        filters=cell(1,2);
        filters{1,1}.meta.Q=Q;
        filters{1,1}.meta.J=J;
        filters{1,1}.meta.P=P;
        filters{1,1}.meta.sigma_psi=sigma_psi;
        filters{1,1}.meta.sigma_phi=sigma_phi;
        filters{1,1}.meta.xi_psi=xi_psi;
        filters{1,1}.meta.phi_dirac=0;

        filters{1,2}.meta.Q=2;
        B=filters{1,2}.meta.Q;
        sigma0 = 2/sqrt(3);
        phi_bw_multiplier=1+(filters{1,2}.meta.Q==1);
        sigma_psi=1/2*sigma0/(1-2^(-1/B));
        sigma_phi=sigma_psi/phi_bw_multiplier;
        J=T_to_J(T,filters{1,2}.meta);
        P=round((2^(-1/filters{1,2}.meta.Q)-1/4*sigma0/sigma_phi)/ (1-2^(-1/filters{1,2}.meta.Q)));
        xi_psi=1/2*(2^(-1/filters{1,2}.meta.Q)+1)*pi;
        filters{1,2}.meta.J=J;        
        filters{1,2}.meta.P=P;
        filters{1,2}.meta.sigma_psi=sigma_psi;
        filters{1,2}.meta.sigma_phi=sigma_phi;
        filters{1,2}.meta.xi_psi=xi_psi;
        filters{1,2}.meta.phi_dirac=0;

        [psi_xi,psi_bw,phi_bw] = morlet_freq_1d(filters{1,1}.meta);
        [psi_xi2,psi_bw2,phi_bw2] = morlet_freq_1d(filters{1,2}.meta);
        Total=0;
        for ii=1:length(psi_xi)
            Total=length(find(psi_bw(ii)>psi_xi2))+Total;
        end
        featRow(Wnum,Q)=Total+1+length(psi_xi);
    end
end

featRow=featRow';
featCol=featCol';
featlen=featCol.*featRow;

figure
imagesc(featlen)
colorbar
title('feature length visualization')
xlabel('how many windowns *10')
ylabel('Q value')

figure
imagesc(featRow)
colorbar
title('feature Rows visualization')
xlabel('how many windowns *10')
ylabel('Q value')

figure
imagesc(featCol)
colorbar
title('feature Columns visualization')
xlabel('how many windowns *10')
ylabel('Q value')
