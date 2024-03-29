function NBRaster_Drawing(File,NBurst_Parameters)
% 基于网络爆发起止时间绘制光栅图.

% 获取电极名称.
Names = fieldnames(File);

% 获取网络爆发参数，并进行提取重构.
neu_burst = [NBurst_Parameters.T_start' NBurst_Parameters.T_end'];

% 设置线条宽度.
line_wid = 2;
% 设置时间跨度s.
time = 10;

% 外层控制输出图个数 目前60s的间隔
for t=1:1
    start_time = (t-1) * time % 开始时间
    end_time = t * time % 结束时间
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
            plot([bin_Data(f),bin_Data(f)],[i-1,i],'Color',[0,0,0],'linewidth',line_wid); 

            set(gca,'xtick',[],'ytick',[]); % 取出坐标
            set(gca,'Visible','off'); % 取出边框
            set(gca,'XLim',[0 time]);
            hold on
        end
         
        % 在单通道爆发绘制后，对同步爆发范围内的数据进行标红.
        % 1. 范围内的全部标注.
        for j = 1 : length(neu_burst)

            neu_burst_data = find(bin_Data >= neu_burst(j,1) & bin_Data <= neu_burst(j,2));
            
%             for k = 1 : length(neu_burst_data)
%                 plot([bin_Data(neu_burst_data(k)),bin_Data(neu_burst_data(k))],[i-1,i],'Color',[0,1,0],'linewidth',line_wid);
%             end
            
            % 绘制边界
            % if ~isempty(neu_burst_data)
            %      plot([bin_Data(neu_burst_data(1)),bin_Data(neu_burst_data(1))],[i-1,i],'Color',[1,0,0],'linewidth',1.8);
            %      plot([bin_Data(neu_burst_data(end)),bin_Data(neu_burst_data(end))],[i-1,i],'Color',[1,0,0],'linewidth',1.8);
            % end
            
            if (neu_burst(j,1) >= start_time & neu_burst(j,2) <= end_time)
                plot([neu_burst(j,1),neu_burst(j,1)],[i-1,i],'Color',[1,0,0],'linewidth',line_wid);
                plot([neu_burst(j,2),neu_burst(j,2)],[i-1,i],'Color',[1,0,0],'linewidth',line_wid);
            end
            
        end

    end
end