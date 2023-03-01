% 载入神经元放电时间的数据，将其存储为向量spike_times
File = load('E:\Projects\Matlab\data\7-21-beforeSEC-spon-3min-41s.mat');  % 包含多个通道的数据，每个通道是一个一维double数值矩阵
spike_times = []
Names = fieldnames(File)
for i = 1:length(Names)
    rowNames = Names{i,1};
    Data = extractfield(File,rowNames)
    spike_times = [spike_times Data]
end

% 设置参数
tbin = 5;  % 时间窗口大小（以毫秒为单位）
nbins = 200;  % 时间窗口数目
thresh = 0.2;  % 网络爆发的阈值

% 计算Log ISI分布
spike_times = sort(spike_times); % 对时间戳进行排序
ISIs = diff(spike_times);
logISIs = log10(ISIs);
[ISIcount, ISIbins] = hist(logISIs, nbins);
ISIcount = ISIcount / sum(ISIcount);

% 计算每个时间窗口中的发放神经元数目
counts = zeros(nbins,1);
for i = 1:nbins
    tstart = (i-1)*tbin;
    tend = i*tbin;
    counts(i) = sum(spike_times > tstart & spike_times <= tend);
end

% 计算网络爆发指数
burstIndex = zeros(nbins,1);
for i = 1:nbins
    tstart = max(1,i-5);
    tend = min(nbins,i+5);
    burstIndex(i) = sum(counts(tstart:tend)) / ((tend-tstart+1)*tbin);
end

% 判断是否出现网络爆发
burst = find(burstIndex > thresh);

% 将网络爆发时间转换为毫秒
burst_times = burst * tbin;

% 可视化结果
figure;
bar(ISIbins, ISIcount);
title('Log ISI Distribution');
xlabel('Log ISI (ms)');
ylabel('Fraction of Spikes');

figure;
plot((1:nbins)*tbin, burstIndex);
hold on;
plot([0 nbins*tbin], [thresh thresh], 'r--');
title('Burst Index');
xlabel('Time (ms)');
ylabel('Burst Index');
legend('Burst Index', 'Threshold');

