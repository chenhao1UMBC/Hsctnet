close all
clc
clear




opt.plot_fig = 0;
opt.threshold1 = 5e8;
opt.threshold2 = 1e3;
opt.l1 = 8e6; % one time data reading total lenght, len(x)
opt.l2 = 4e3; % output length
opt.loverl = 2e3; % non-overlap length, 
opt.N_samples = 5000;

filenames = {'bt', 'fhss1', 'fhss2', 'wifi1', };
fn = filenames{4};
obj = matfile([fn, '_all.mat']);

x = zeros(opt.l2, opt.N_samples);  % 5000 traning samples
ind_x = 1;

for ii = 0:224
seg = 1;
xx = obj.('x')(1 + 8e6*seg:8e6 + 8e6*seg, 1);
[x, ind_x] = dptsp(xx, x, ind_x, opt);

if ind_x == opt.N_samples + 1
    break
end

end

'done'
save([fn, '_5000.mat'], 'x')
%%
% after squared abs(x).^2:
% w2 threshold 1e9, w1:1e9, f2:5e8, f1:1e9, bt:5e8, ble:5e8


function [x, ind_x] = dptsp(xx, x, ind_x, opt)
    plot_fig = opt.plot_fig;
    threshold1 = opt.threshold1;
    threshold2 = opt.threshold2;
    l1 = opt.l1; % one time data reading total lenght, len(x)
    l2 = opt.l2; % output length
    loverl = opt.loverl; % overlap length
    N_samples = opt.N_samples;
    
    y = abs(xx).^2;
    idx = (y>threshold1);
    ii = 1:l1;
    ind = ii(idx);  % peak indicies, like staircases

    dind = ind(2:end) - ind(1:end-1);  % differential of peaks
    idx2 = (dind>threshold2);  % find peaks
    ii2 = 1:length(dind);  
    ind2 = ii2(idx2);  % find gap index

    for i = 1:length(ind2)
        if i == 1
            data_idx = ind(1:ind2(1)); % index of data
            pt1 = 1;
            pt2 = l2;
            while pt2<ind2(1)
                tt = xx(data_idx(pt1:pt2));
                pt1 = pt1 + loverl;
                pt2 = pt2 + loverl;
                
                if ind_x > N_samples
                    return
                else
                    x(:, ind_x) = tt;
                    ind_x = ind_x + 1;
                end
            end
            
        else
            data_idx = ind(ind2(i-1)+1:ind2(i));
            pt1 = 1;
            pt2 = l2;
            
            while pt2<length(data_idx)
                tt = xx(data_idx(pt1:pt2));
                pt1 = pt1 + loverl;
                pt2 = pt2 + loverl;
                
                if ind_x > N_samples
                    return
                else
                    x(:, ind_x) = tt;
                    ind_x = ind_x + 1;
                end
            end
            

        end
    end
    if plot_fig == 1
        % plotting figures
        tt = xx(data_idx(1:4e3));
        figure; stft(tt)
        tt = xx(1: ind(ind2(1)) );
        figure; stft(tt)

        figure;plot(ind)
        figure;plot(ind(1:end/10))
        figure;plot(dind)

        names = {'ble', 'bt', 'f1', 'f2', 'w1', 'w2'};
        for nn = names
        n = nn{1};
        t = abs(eval([n, '(2:end)'])) - abs(eval([n, '(1:end-1)']));
        % figure;plot(abs(t));title(n)
        % figure;plot(abs(eval(n)));title(n)
        figure;plot(abs(eval(n)).^2);title(n)
        end
    end
end
