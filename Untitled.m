close all
options.M = 2; % M layers
N = 1e5;
fparam.Q = [1 4];
fparam.J = T_to_J(N,fparam);
fparam.filter_type = {'gabor_1d','morlet_1d'};
[Wop,filters] = wavelet_factory_1d(N, fparam, options);


t = 1:N;
figure
x = sin(t/100) .* sin(2*t/10) .* cos(t) + t/N;
y = cos(t/100) .* cos(2*t/10) .* sin(10000*t) + t.*t/N/1e4;
z = x + y;
plot(x)
hold on 
plot (y)
plot(z)
hold off
legend('x', 'x', 'z')

figure;
for m = 1:2
    subplot(1,2,m);
    hold on; 
    for k = 1:length(filters{m}.psi.filter)
        plot(realize_filter(filters{m}.psi.filter{k}, N)); 
        fwave{m}.psifil{k} = realize_filter(filters{m}.psi.filter{k}, N);
        xt = ifft(x.*fwave{m}.psifil{k});
        yt = ifft(y.*fwave{m}.psifil{k});
        zt
    end
    hold off;
%     ylim([0 1.5]);
%     xlim([1 5*N/8]);
end

plot(realize_filter(filters{1,2}.phi.filter, N))