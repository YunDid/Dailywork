% 加载数据，并整理所有 Spike 于一行.
File = load('E:\Github\Dailywork\data\Network_burst\7-23\7-before-sec-spon-10min\7-before-sec-spon-10min.mat');
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
spike_s(spike_s == 0) = [];
N = (10:20);
Steps = 10.^(-5:.05:1.5);
HistogramISIn(spike_s,N,Steps);

% 获取网络同步爆发起始时间数据.
NN = 10;
isi_nn = 0.112;
[NBurst_Parameters, SpikeBurstNumber] = BurstDetectISIn(spike_sorted, NN, isi_nn);
neu_burst = [NBurst_Parameters.T_start' NBurst_Parameters.T_end'];

% 统计参与同步爆发的所有Spike个数.
NBurst_Parameters.Num_AllSpikesInNB = sum(NBurst_Parameters.S);
% 统计同步爆发的次数.
NBurst_Parameters.Num_NB = length(NBurst_Parameters.T_start);
% 统计每次同步爆发之间的间隔时间.
NBurst_Parameters.Duration_NB = NBurst_Parameters.T_end - NBurst_Parameters.T_start;
% 每次同步爆发之间的间隔时间.
NBurst_Parameters.ISI_NB =  NBurst_Parameters.T_end(2:end) - NBurst_Parameters.T_start(1:end-1);
% 统计每次同步爆发参与的电极数.
NBurst_Parameters.Num_electrodes = zeros(1,length(NBurst_Parameters.T_start));
% 每次同步爆发具体的参与电极编号以及对应编号下的参与spike个数.
NBurst_Parameters.Sequence_Ele = cell(NBurst_Parameters.Num_NB,2);
% 基于电极而言，参与了多少次同步爆发，以及电极参与了哪些同步爆发(具化到每个电极对应相应的同步爆发序号).
Electrode_Participation.Index = [1:length(Names)];
Electrode_Participation.Index_NBurst = cell(59,2);
Electrode_Participation.Index_NBurst(:,1) =  Names;
Electrode_Participation.Num_NBurst = zeros(1,length(Names));

% 外层控制输出图个数 目前60s的间隔
for t=1:1
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

            set(gca,'xtick',[],'ytick',[]); % 取出坐标
            set(gca,'Visible','off'); % 取出边框
            set(gca,'XLim',[0 10]);
            hold on
        end
         
        % 在单通道爆发绘制后，对同步爆发范围内的数据进行标红.
        % 1. 范围内的全部标注.
        % 累加器 存放当前电极参与同步爆发的序号列表.
        Sequence_list = [];
        for j = 1 : length(neu_burst)
            
            % 创建 同步爆发/参与电极列表 对.
            NBurst_Parameters.Sequence_Ele(j,1) = {j};
            
            neu_burst_data = find(bin_Data >= neu_burst(j,1) & bin_Data <= neu_burst(j,2));
           
            neu_burst_alldata = find(Data >= neu_burst(j,1) & Data <= neu_burst(j,2));
            
            if ~isempty(neu_burst_alldata)
                % 统计当前同步爆发下参与的电极序号列表.
                NBurst_Parameters.Sequence_Ele(j,2) = {[cell2mat(NBurst_Parameters.Sequence_Ele(j,2)) i]};
                % 统计当前电极参与同步爆发的序号列表.
                Sequence_list = [Sequence_list j];
                % 统计当前电极参与的网络爆发次数. 
                Electrode_Participation.Num_NBurst(i) = Electrode_Participation.Num_NBurst(i) + 1;
                % 统计参与的电极数.
                NBurst_Parameters.Num_electrodes(j) = NBurst_Parameters.Num_electrodes(j) + 1;
            end
            
            for k = 1 : length(neu_burst_data)
                plot([bin_Data(neu_burst_data(k)),bin_Data(neu_burst_data(k))],[i-1,i],'Color',[0,1,0],'linewidth',0.8);
            end
            
            % 绘制边界
            % if ~isempty(neu_burst_data)
            %      plot([bin_Data(neu_burst_data(1)),bin_Data(neu_burst_data(1))],[i-1,i],'Color',[1,0,0],'linewidth',0.8);
            %      plot([bin_Data(neu_burst_data(end)),bin_Data(neu_burst_data(end))],[i-1,i],'Color',[1,0,0],'linewidth',0.8);
            % end
            
            if (neu_burst(j,1) >= start_time & neu_burst(j,2) <= end_time)
                plot([neu_burst(j,1),neu_burst(j,1)],[i-1,i],'Color',[1,0,0],'linewidth',0.8);
                plot([neu_burst(j,2),neu_burst(j,2)],[i-1,i],'Color',[1,0,0],'linewidth',0.8);
            end
            
        end
        
        Electrode_Participation.Index_NBurst{i,2} = Sequence_list;
        
    end
end