smp_len = 2e6;
k = 1;
dir='/home/chenhao1/Documents/MATLAB/LMdata/';

% sig_name = 'wifi1';
% var_name = 'x';

%sig_name = 'Bluetooth2';
%var_name = 'x';

sig_name = 'zigbee1';
var_name = 'x';

%sig_name = 'Ambient1';
%var_name = 'x';

fname = [dir sig_name];

obj=matfile(fname);
x=obj.(var_name)(((1+(k-1)*smp_len):k*smp_len),1);

% x=circshift(x,1e6);

figure
spect_v2(x);
title(sig_name)