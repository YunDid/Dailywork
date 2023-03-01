function HistogramISIn( SpikeTimes, N, Steps )

figure;
hold on;
map=hsv(length(N));

% 绘制ISI分布。个直方图，x轴为log(ISI)，y轴为ISI在所有ISI中的占比.
% 表明神经元放电时间间隔(ISI)的概率分布情况.
cnt=0;
for FRnum = N
    cnt = cnt+1;
    % 保证操作数长度相等. 但是为何要这样确定ISI的值？    
    ISI_N = SpikeTimes( FRnum:end ) - SpikeTimes( 1:end-(FRnum-1) );
    n = histc( ISI_N*1000, Steps*1000 );
    n = smooth(n,'lowess');
    plot(Steps*1000, n/sum(n),'.-', 'color', map(cnt,:))
end


xlabel 'ISI, T_i - T_{i-(N-1) _{ }} [ms]' 
ylabel 'Probability [%]' 
set(gca,'xscale','log') 
set(gca,'yscale','log')

