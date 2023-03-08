function [ISIN] = HistogramISIn( SpikeTimes, N, Steps )

figure;
hold on;
map=hsv(length(N));

% 绘制ISI分布。个直方图，x轴为log(ISI)，y轴为ISI在所有ISI中的占比.
% 表明神经元放电时间间隔(ISI)的概率分布情况.
cnt=0;
sum_prob = 0;
for FRnum = N
    cnt = cnt+1;
    % 保证操作数长度相等. 但是为何要这样确定ISI的值？    
    ISI_N = SpikeTimes( FRnum:end ) - SpikeTimes( 1:end-(FRnum-1) );
    n = histc( ISI_N*1000, Steps*1000 );
    n = smooth(n,'lowess');
    prob = n / sum(n);
    % 求和，准备求平均值.
    sum_prob = sum_prob + prob;
    
    plot(Steps*1000, prob,'.-', 'color', map(cnt,:));
end

% 设置坐标轴.
xlabel 'ISI, T_i - T_{i-(N-1) _{ }} [ms]' 
ylabel 'Probability [%]' 
set(gca,'xscale','log') 
set(gca,'yscale','log')

% 找寻直方图的波峰，波谷，确定阈值ISIN.

% 确定曲线y的均值.
% avg_prob = sum_prob / cnt;
avg_prob = prob;

% 使用 findpeaks 函数查找直方图中的波峰和波谷。
[pks,locs] = findpeaks(avg_prob);  % 找到波峰
[valleys,locs_valleys] = findpeaks(-avg_prob);  % 找到波谷

% 找到波谷的 x 值。
bin_centers = (Steps(1:end-1) + Steps(2:end)) / 2;
ISIN = bin_centers(locs_valleys)

% 确定最低的波谷，即高度最小的波谷。
% [~, min_idx] = min(valleys);
% min_valley_loc = locs_valleys(min_idx);

% 找到波谷的 x 值。
bin_centers = (Steps(1:end-1) + Steps(2:end)) / 2;
vec_locx = bin_centers(locs_valleys);
vec_locx = vec_locx(vec_locx >= 0.1 & vec_locx <= 0.6)
ISIN = vec_locx(end);



