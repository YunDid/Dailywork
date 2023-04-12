% 提取文件目录.
filepath = 'E:\Github\Dailywork\data\MATDATA';
dirfiles = dir(fullfile(filepath));
dirfiles = dirfiles(3:end);
filenames = {dirfiles.name};

NBurst_Parameters = cell(1,2);
Electrode_Participation = cell(1,2);

% for i = 1:length(filenames)
for i = 8
    % 顺序读取目录下的所有文件数据. - method_2
    datapath = fullfile('E:\Github\Dailywork\data\MATDATA\',char(filenames(i)));
    dirdata = dir(fullfile(datapath,'*.mat'));
    plyName = {dirdata.name};
    % 顺序加载数据.mat文件,获取绘图参数.
    Spike_nums = []; 
    % 遍历当前文件下的所有.mat数据.
    for j = 1:length(plyName)
%       for j = 2
        File = load(fullfile('E:\Github\Dailywork\data\MATDATA\',char(filenames(i)),'\',char(plyName(j))));
        
        % 加载数据，并整理所有 Spike 于一行.
        Names = fieldnames(File)
        spikes = [];
        for k = 1:length(Names)
            rowNames = Names{k,1};
            data = extractfield(File,rowNames);
            spikes = [spikes data];
        end
        
         % 对spike进行排序以便进行 logISI 算法.
        spikes = sort(spikes);
        
         % 绘制 logISI 直方图，确定阈值参数.
        spikes(spikes == 0) = [];
        N = (2:10);
        Steps = 10.^(-5:.05:1.5);
        ISI_N = HistogramISIn(spikes,N,Steps);
        
        [NBurst,Electrode] = GetNBusrtParameters(File,spikes,ISI_N);
        NBurst_Parameters(j) = {NBurst};
        Electrode_Participation(j) = {Electrode};             
      end
end

% 统计 Spike 总数.
Spike_nums = [Spike_nums length(spikes)];
% 统计每秒的 Spike 数-放电率.
Firing_rate = Spike_nums / 600;
% 统计每分钟的爆发数-爆发率.
Burst_rate = [NBurst_Parameters{1}.Num_NB NBurst_Parameters{2}.Num_NB];
Burst_rate = Burst_rate / 10;
% 统计平均网络爆发时间间隔.
Mean_IBI = [sum(NBurst_Parameters{1}.ISI_NB)/(NBurst_Parameters{1}.Num_NB) sum(NBurst_Parameters{2}.ISI_NB)/(NBurst_Parameters{2}.Num_NB)];
% 统计平均每次爆发中 Spike 个数.
Mean_NumSpikeofEachBurst = [sum(NBurst_Parameters{1}.S)/(NBurst_Parameters{1}.Num_NB) sum(NBurst_Parameters{2}.S)/(NBurst_Parameters{2}.Num_NB)];
% 统计平均每次爆发中参与的电极个数.
Mean_NumElefEachBurst = [sum(NBurst_Parameters{1}.Num_electrodes)/(NBurst_Parameters{1}.Num_NB) sum(NBurst_Parameters{2}.Num_electrodes)/(NBurst_Parameters{2}.Num_NB)];
% 绘制对应网络爆发的光栅图.
% NBRaster_Drawing(File,NBurst);

% bar(Spike_nums);    
% bar(Firing_rate);