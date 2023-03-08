function Getstatisticsdata(NBurst_Parameters)

% 基于统计到的网络爆发参数对数据进行统计分析.
map=hsv(length(NBurst_Parameters));
% 网络爆发持续时间.
mean_Duration_NB = [];
std_Duration_NB = [];
% 网络爆发ISI.
mean_ISI_NB = [];
std_ISI_NB = [];
% 每次网络爆发擦参与的电极数.
mean_Num_electrodes = [];
std_Num_electrodes = [];
% 每次网络爆发参与的spike数.
mean_Num_spikes = [];
std_Num_spikes  = [];

for i = 1:length(NBurst_Parameters)
    mean_Duration_NB = [mean_Duration_NB mean(NBurst_Parameters{i}.Duration_NB)];
    std_Duration_NB = [std_Duration_NB std(NBurst_Parameters{i}.Duration_NB)];
    
    mean_ISI_NB = [mean_ISI_NB mean(NBurst_Parameters{i}.ISI_NB)];
    std_ISI_NB = [std_ISI_NB std(NBurst_Parameters{i}.ISI_NB)];
    
    mean_Num_electrodes = [mean_Num_electrodes mean(NBurst_Parameters{i}.Num_electrodes)];
    std_Num_electrodes = [std_Num_electrodes std(NBurst_Parameters{i}.Num_electrodes)];
    
    mean_Num_spikes = [mean_Num_spikes mean(NBurst_Parameters{i}.S)];
    std_Num_spikes = [std_Num_spikes std(NBurst_Parameters{i}.S)];
    % plot(1:length(NBurst_Parameters{i}.Duration_NB),NBurst_Parameters{i}.Duration_NB,'.-','color', map(i,:),'linewidth',0.8); 
    % hold on;
end

save('Parameter.mat','mean_Duration_NB','std_Duration_NB','mean_ISI_NB','std_ISI_NB','mean_Num_electrodes','std_Num_electrodes','mean_Num_spikes','std_Num_spikes');

% bar(mean_data);
% bar(std_data);