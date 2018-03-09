function spect_v2(x)

t_resol = 1000;

len_x = length(x); % xlen
len_window = floor(len_x/t_resol);
%nov = floor(nsc/2); % hop
%nff = max(256,2^nextpow2(nsc));% nfft number of fft points 

spectrogram(x,len_window,[],[],4e7,'yaxis','centered')
