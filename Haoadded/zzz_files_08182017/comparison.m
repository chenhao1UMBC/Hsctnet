s1 = num2str(opt.cn(1));
s2 = num2str(opt.cn(2));
s3 = num2str(opt.cn);
s4 = num2str(nsamples);
s5 = num2str(q);
s6 = num2str(n);
s7 = ['_M', num2str(options.M)];

if opt.norm == 1
    load(['norm_mix',s1,'db',s4,'_1classqn',s5,s6,'_positive',s7,'_snr2000power_0.mat'])
    load(['norm_mix',s1,'db',s4,'_1classqn',s5,s6,'_negative',s7,'_snr2000power_0.mat'])
else
    load(['mix',s1,'db',s4,'_1classqn',s5,s6,'_positive',s7,'_snr2000power_0.mat'])
    load(['mix',s1,'db',s4,'_1classqn',s5,s6,'_negative',s7,'_snr2000power_0.mat'])  
end
featln = size(db2.features,2)/nsamples;
for ii=1:nsamples                
    db2.features(:,1+(ii-1)*featln:ii*featln)=...
        flip(flip(db2.features(:,1+(ii-1)*featln:ii*featln),2),1);
end
ft{1} = [db.features;flip(db2.features, 1)];

if opt.norm == 1
    load(['norm_mix',s2,'db',s4,'_1classqn',s5,s6,'_positive',s7,'_snr2000power_0.mat'])
    load(['norm_mix',s2,'db',s4,'_1classqn',s5,s6,'_negative',s7,'_snr2000power_0.mat'])
else
    load(['mix',s2,'db',s4,'_1classqn',s5,s6,'_positive',s7,'_snr2000power_0.mat'])
    load(['mix',s2,'db',s4,'_1classqn',s5,s6,'_negative',s7,'_snr2000power_0.mat'])
end
for ii=1:nsamples                
    db2.features(:,1+(ii-1)*featln:ii*featln)=...
        flip(flip(db2.features(:,1+(ii-1)*featln:ii*featln),2),1);
end
ft{2} = [db.features;flip(db2.features, 1)];

if opt.norm == 1
    load(['norm_mix',s3,'db',s4,'_1classqn',s5,s6,'_positive',s7,'_snr2000power_0  0.mat'])
    load(['norm_mix',s3,'db',s4,'_1classqn',s5,s6,'_negative',s7,'_snr2000power_0  0.mat'])
else
    load(['mix',s3,'db',s4,'_1classqn',s5,s6,'_positive',s7,'_snr2000power_0  0.mat'])
    load(['mix',s3,'db',s4,'_1classqn',s5,s6,'_negative',s7,'_snr2000power_0  0.mat'])
end
for ii=1:nsamples                
    db2.features(:,1+(ii-1)*featln:ii*featln)=...
        flip(flip(db2.features(:,1+(ii-1)*featln:ii*featln),2),1);
end
t1 = [db.features;flip(db2.features, 1)];
t2 = ft{1} + ft{2};

Stat_v = zeros(1, nsamples);
for ii=1:nsamples
    nt1 = t1(:,1+(ii-1)*featln:ii*featln);
    nt2 = t2(:,1+(ii-1)*featln:ii*featln);
%     nt1 = nt1/norm(nt1, 'fro');
%     nt2 = nt2/norm(nt2, 'fro');
    Stat_v(ii) = norm(nt1 - 0.5*nt2, 'fro')/norm(nt1, 'fro');
%     Stat_v(ii) = norm(nt1 - nt2, 'fro');
end
% fprintf('averaged distance\n')
avd = sum(Stat_v)/nsamples; %averaged distance
    
