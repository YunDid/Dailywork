File = load('E:\Projects\Matlab\data\12-23-1-before-10minspon.mat');
File2 = load('E:\Projects\Matlab\data\burst_data.mat');
Names = fieldnames(File)

num = xlsread('E:\Projects\Matlab\data\1-before-spon10min.xlsx');
% 网络同步爆发起始时间数据.
neu_burst = xlsread('E:\Projects\Matlab\data\12-23-burst.xlsx');


% 外层控制输出图个数 目前60s的间隔
for t=1:1
    start_time = (t-1) * 10 % 开始时间
    end_time = t * 10 % 结束时间
    % for i = 1:
    for i = 1:length(Names)
%     for i = 1:3
        rowNames = Names{i,1};
        % 1个电极对应的数据 
        Data = extractfield(File,rowNames);
        % 取当前电极下的Burst数据.
        % burstData = File2.(rowNames);
        burstData = num(:,(i-1) * 6 + 1 : 6 * i)
        % 取出每个电极符合这个范围内的数据
        bin_Data = Data(Data>=double(start_time) & Data<double(end_time));
        % 计数变量，用来定位 burststart 的spike.
        pos = 1;
        % burstnum 用来记录当前电极下爆发持续的spike个数.
        burstnum = burstData(pos,4);
        for f = 1:length(bin_Data)
                % 64 个电极分区域绘制.
                subplot(64,1,i);
                % 可更改颜色和粗细[0.067,0.443,0.705] % plot(bin_Data(f),i,".",'Color',[0,0,0]); 
                plot([bin_Data(f),bin_Data(f)],[i-1,i],'Color',[0,0,0],'linewidth',0.8); 
                % 在普通绘制后，对burst范围内的数据进行标红.
                % 越界控制.
                if burstData(pos,4) ~= NaN
                    if (bin_Data(f) == burstData(pos,1)) | (burstnum ~= NaN & burstnum ~= 0)                      
                        if (bin_Data(f) == burstData(pos,1))
                            burstnum = burstData(pos,4);
                        end
                        burstnum = burstnum - 1;
                        if burstnum == 0
                            pos = pos + 1;                           
                        end
                        plot([bin_Data(f),bin_Data(f)],[i-1,i],'Color',[1,0,0],'linewidth',0.8); 
                    end
                end
                
% 弃置               
%                 for j = 1 : length(neu_burst)
%                     % 将于同步爆发下的起始spike标蓝.
%                     if (bin_Data(f) == neu_burst(j))
%                         plot([bin_Data(f),bin_Data(f)],[i-1,i],'Color',[0,0,1],'linewidth',0.8);
%                     end
%                 end 

                % 在单通道爆发绘制后，对同步爆发范围内的数据进行标红.
                % 1. 范围内的全部标注.
                for j = 1 : length(neu_burst)
                    
                    neu_burst_data = find(bin_Data >= neu_burst(j,1) & bin_Data <= neu_burst(j,2));
                    for k = 1 : length(neu_burst_data)
                        plot([bin_Data(neu_burst_data(k)),bin_Data(neu_burst_data(k))],[i-1,i],'Color',[0,0,1],'linewidth',0.8); 
                    end
                    
                    % 绘制边界
                    if (neu_burst(j,1) >= start_time & neu_burst(j,2) <= end_time)
                        plot([neu_burst(j,1),neu_burst(j,1)],[i-1,i],'Color',[0.5,0.5,0.5],'linewidth',0.8); 
                        plot([neu_burst(j,2),neu_burst(j,2)],[i-1,i],'Color',[0.5,0.5,0.5],'linewidth',0.8); 
                    end
                    
                end
                
                % 2. 仅仅标注起始边界.               
%                 for j = 1 : length(neu_burst)
%                     
%                     neu_burst_data = find(bin_Data == neu_burst(j,1));
%                     if ~isempty(neu_burst_data)
%                          plot([bin_Data(neu_burst_data(1)),bin_Data(neu_burst_data(1))],[i-1,i],'Color',[0,1,0],'linewidth',1);
%                          hold on;
%                     end
%                     
%                     neu_burst_data1 = find(bin_Data == neu_burst(j,2));
%                     if ~isempty(neu_burst_data1)
%                          plot([bin_Data(neu_burst_data1(1)),bin_Data(neu_burst_data1(1))],[i-1,i],'Color',[0,1,0],'linewidth',1);
%                          hold on;
%                     end
%                     
%                 end
                
                set(gca,'xtick',[],'ytick',[]); % 取出坐标
                set(gca,'Visible','off'); % 取出边框
%                 set(gca,'XLim',[0 10]);
                hold on
         end
    end
    % print(gcf,'E:\AAAProjects\Matlab\save\SWW-5MINN.jpg','-r600','-djpeg')%保存路径
end