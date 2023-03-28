% 提取文件目录.
filepath = 'E:\Github\Dailywork\data\MATDATA';
dirfiles = dir(fullfile(filepath));
dirfiles = dirfiles(3:end);
filenames = {dirfiles.name};

% for i = 1:length(filenames)
for i = 3
    % 顺序读取目录下的所有文件数据. - method_2
    datapath = fullfile('E:\Github\Dailywork\data\MATDATA\',char(filenames(i)));
    dirdata = dir(fullfile(datapath,'*.mat'));
    plyName = {dirdata.name};
    % 顺序加载数据.mat文件,获取绘图参数.
    Spike_nums = []; 
    % 遍历当前文件下的所有.mat数据.
    for j = 1:length(plyName)
%       for j = 7
        File = load(fullfile('E:\Github\Dailywork\data\MATDATA\',char(filenames(i)),'\',char(plyName(j))));
        
        % 加载数据，并整理所有 Spike 于一行.
        Names = fieldnames(File)
        spikes = [];
        for k = 1:length(Names)
            rowNames = Names{k,1};
            data = extractfield(File,rowNames);
            spikes = [spikes data];
        end
        
        Spike_nums = [Spike_nums length(spikes)];
        Firing_rate = Spike_nums / 600;
        % 绘制对应网络爆发的光栅图.
        % NBRaster_Drawing(File,NBurst);
      end
    
end

bar(Spike_nums);
% bar(Firing_rate);