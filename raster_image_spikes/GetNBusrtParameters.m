function [NBurst_Parameters,Electrode_Participation] = GetNBusrtParameters(File,spike_sorted,ISI_N)
% 获取网络爆发参数，以结构体形式返回.

% 获取网络同步爆发起始时间数据.
[NBurst_Parameters, SpikeBurstNumber] = BurstDetectISIn(spike_sorted, 10, ISI_N);
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
Names = fieldnames(File);
Electrode_Participation.Index = [1:length(Names)];
Electrode_Participation.Index_NBurst = cell(length(Names),2);
Electrode_Participation.Index_NBurst(:,1) =  Names;
Electrode_Participation.Num_NBurst = zeros(1,length(Names));

for i = 1:length(Names)
    rowNames = Names{i,1};
    % 1个电极对应的数据
    Data = extractfield(File,rowNames);
    % 累加器 存放当前电极参与同步爆发的序号列表.
    Sequence_list = [];
    for j = 1 : length(neu_burst)
        
        % 创建 同步爆发/参与电极列表 对.
        NBurst_Parameters.Sequence_Ele(j,1) = {j};
        
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
        
    end
    
    Electrode_Participation.Index_NBurst{i,2} = Sequence_list;
    
end
