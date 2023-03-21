% 顺序读取目录下的所有文件数据. - method_1
% FolderPath = 'E:\Github\Dailywork\data\Network_burst\7-23\'
% MatPath  = dir([FolderPath '*.mat']);

% 提取文件目录.
filepath = 'E:\Github\Dailywork\data\Network_burst';
dirfiles = dir(fullfile(filepath));
dirfiles = dirfiles(3:end);
filenames = {dirfiles.name};

for i = 1:length(filenames)
% for i = 2
    % 顺序读取目录下的所有文件数据. - method_2
    datapath = fullfile('E:\Github\Dailywork\data\Network_burst\',char(filenames(i)));
    dirdata = dir(fullfile(datapath,'*.mat'));
    plyName = {dirdata.name};
    % 顺序加载数据.mat文件,获取爆发参数.
    NBurst_Parameters = cell(1,length(plyName));
    Electrode_Participation = cell(1,length(plyName));
    
    % 遍历当前文件下的所有.mat数据.
    for j = 1:length(plyName)
        File = load(fullfile('E:\Github\Dailywork\data\Network_burst\',char(filenames(i)),'\',char(plyName(j))));
        
        % 加载数据，并整理所有 Spike 于一行.
        Names = fieldnames(File)
        spikes = [];
        for k = 1:length(Names)
            rowNames = Names{k,1};
            data = extractfield(File,rowNames);
            spikes = [spikes data];
        end
        
        % 对spike进行排序以便进行 logISI 算法.
        spike_sorted = sort(spikes);
        
        % 绘制 logISI 直方图，确定阈值参数.
        spike_sorted(spike_sorted == 0) = [];
        N = (2:10);
        Steps = 10.^(-5:.05:1.5);
        ISI_N = HistogramISIn(spike_sorted,N,Steps);
        
        % 进行网络爆发检测，并获取网络爆发参数.
        [NBurst,Electrode] = GetNBusrtParameters(File,spike_sorted,ISI_N);
        NBurst_Parameters(j) = {NBurst};
        Electrode_Participation(j) = {Electrode};
        
        % 绘制对应网络爆发的光栅图.
        NBRaster_Drawing(File,NBurst);
    end
    
    Getstatisticsdata(NBurst_Parameters,filenames(i));
    
end