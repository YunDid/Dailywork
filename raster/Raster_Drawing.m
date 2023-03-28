function Raster_Drawing(File)
% 基于网络爆发起止时间绘制光栅图.

% 获取电极名称.
Names = fieldnames(File);

% 外层控制输出图个数 目前60s的间隔
for t=1:1
    start_time = (t-1) * 30 % 开始时间
    end_time = t * 30 % 结束时间
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
            set(gca,'XLim',[0 30]);
            hold on
        end
    end
end