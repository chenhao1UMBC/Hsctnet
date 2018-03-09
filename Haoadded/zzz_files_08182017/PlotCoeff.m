
if (exist ('src'))
    fprintf('\n existing source\n')
else
    run('addpath_scatnet.m')
    mkdir('/home/chenhao/Matlab/LMData2')
    addpath(genpath('/home/chenhao/Matlab/LMData2'));
    src = gtzan_src('Haoadded/haomix390_9');
end

if (exist('db')) & (exist('db2'))
    fprintf('\n existing database\n')
else
    load('db390_9class_positive_renorm_snr20','db')
    load('db390_9class_negative_renorm_snr20','db2')
end
close all
for whch=1:9
    plotfeature(db,src, whch);
end