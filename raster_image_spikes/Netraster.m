% 加载数据，并整理所有 Spike 于一行.
File = load('E:\Projects\Matlab\data\Network_burst\7-23\1-before-spon-10min\before-spon-10min.mat');
Names = fieldnames(File)
spikes = [];
for k = 1:length(Names)
    rowNames = Names{k,1};
    data = extractfield(File,rowNames);
    spikes = [spikes data];
end

% 排序.
spike_sorted = sort(spikes);

% 绘制 logISI 直方图，确定阈值参数.
spike_s = spike_sorted;
spike_s(spike_s==0)=[];
N = (10:20);
Steps = 10.^(-5:.05:1.5);
HistogramISIn(spike_s,N,Steps)

% 获取网络同步爆发起始时间数据.
NN = 10;
isi_nn = 0.044;
[Burst, SpikeBurstNumber] = BurstDetectISIn( spike_sorted, NN, isi_nn);
neu_burst = [Burst.T_start' Burst.T_end']

% 外层控制输出图个数 目前60s的间隔
for t=2:2
    start_time = (t-1) * 10 % 开始时间
    end_time = t * 10 % 结束时间
    % for i = 1:
    for i = 1:length(Names)
        rowNames = Names{i,1};
        % 1个电极对应的数据 
        Data = extractfield(File,rowNames);
        % 取出每个电极符合这个范围内的数据
        bin_Data = Data(Data>=double(start_time) & Data<double(end_time));
        
        for f = 1:length(bin_Data)
            % 64 个电极分区域绘制.
            subplot(64,1,i);
            % 可更改颜色和粗细[0.067,0.443,0.705] % plot(bin_Data(f),i,".",'Color',[0,0,0]); 
            plot([bin_Data(f),bin_Data(f)],[i-1,i],'Color',[0,0,0],'linewidth',0.8); 
            
            % 在单通道爆发绘制后，对同步爆发范围内的数据进行标红.
            % 1. 范围内的全部标注.
            for j = 1 : length(neu_burst)
                    
                neu_burst_data = find(bin_Data >= neu_burst(j,1) & bin_Data <= neu_burst(j,2));
                for k = 1 : length(neu_burst_data)
                    plot([bin_Data(neu_burst_data(k)),bin_Data(neu_burst_data(k))],[i-1,i],'Color',[0,1,0],'linewidth',0.8); 
                end
                
                % 绘制边界
%                 if ~isempty(neu_burst_data)
%                     plot([bin_Data(neu_burst_data(1)),bin_Data(neu_burst_data(1))],[i-1,i],'Color',[1,0,0],'linewidth',0.8);
%                     plot([bin_Data(neu_burst_data(end)),bin_Data(neu_burst_data(end))],[i-1,i],'Color',[1,0,0],'linewidth',0.8);
%                 end

                if (neu_burst(j,1) >= start_time & neu_burst(j,2) <= end_time)
                    plot([neu_burst(j,1),neu_burst(j,1)],[i-1,i],'Color',[1,0,0],'linewidth',0.8); 
                    plot([neu_burst(j,2),neu_burst(j,2)],[i-1,i],'Color',[1,0,0],'linewidth',0.8); 
                end
                    
            end

            set(gca,'xtick',[],'ytick',[]); % 取出坐标
            set(gca,'Visible','off'); % 取出边框
%           set(gca,'XLim',[0 10]);
            hold on
         end
    end
end