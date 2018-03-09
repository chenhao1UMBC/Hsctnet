% parellel computing practice
% parpool('local', 4)
tic
a=randn(10000,10000);
b=randn(1000,1000);
% spmd
%   gpuDevice(labindex);
  ga = gpuArray(a);
  gb= gpuArray(b);
  bf=fft(gb);
  af=fft(ga);
% end
toc

tic
  bf=fft(b);
  af=fft(a);
toc
