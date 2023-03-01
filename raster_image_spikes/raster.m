File = load('E:\Projects\Matlab\data\12-23-1-before-10minspon.mat');
File2 = load('E:\Projects\Matlab\data\burst_data.mat');
Names = fieldnames(File)

num = xlsread('E:\Projects\Matlab\data\1-before-spon10min.xlsx');
% ����ͬ��������ʼʱ������.
neu_burst = xlsread('E:\Projects\Matlab\data\12-23-burst.xlsx');


% ���������ͼ���� Ŀǰ60s�ļ��
for t=1:1
    start_time = (t-1) * 10 % ��ʼʱ��
    end_time = t * 10 % ����ʱ��
    % for i = 1:
    for i = 1:length(Names)
%     for i = 1:3
        rowNames = Names{i,1};
        % 1���缫��Ӧ������ 
        Data = extractfield(File,rowNames);
        % ȡ��ǰ�缫�µ�Burst����.
        % burstData = File2.(rowNames);
        burstData = num(:,(i-1) * 6 + 1 : 6 * i)
        % ȡ��ÿ���缫���������Χ�ڵ�����
        bin_Data = Data(Data>=double(start_time) & Data<double(end_time));
        % ����������������λ burststart ��spike.
        pos = 1;
        % burstnum ������¼��ǰ�缫�±���������spike����.
        burstnum = burstData(pos,4);
        for f = 1:length(bin_Data)
                % 64 ���缫���������.
                subplot(64,1,i);
                % �ɸ�����ɫ�ʹ�ϸ[0.067,0.443,0.705] % plot(bin_Data(f),i,".",'Color',[0,0,0]); 
                plot([bin_Data(f),bin_Data(f)],[i-1,i],'Color',[0,0,0],'linewidth',0.8); 
                % ����ͨ���ƺ󣬶�burst��Χ�ڵ����ݽ��б��.
                % Խ�����.
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
                
% ����               
%                 for j = 1 : length(neu_burst)
%                     % ����ͬ�������µ���ʼspike����.
%                     if (bin_Data(f) == neu_burst(j))
%                         plot([bin_Data(f),bin_Data(f)],[i-1,i],'Color',[0,0,1],'linewidth',0.8);
%                     end
%                 end 

                % �ڵ�ͨ���������ƺ󣬶�ͬ��������Χ�ڵ����ݽ��б��.
                % 1. ��Χ�ڵ�ȫ����ע.
                for j = 1 : length(neu_burst)
                    
                    neu_burst_data = find(bin_Data >= neu_burst(j,1) & bin_Data <= neu_burst(j,2));
                    for k = 1 : length(neu_burst_data)
                        plot([bin_Data(neu_burst_data(k)),bin_Data(neu_burst_data(k))],[i-1,i],'Color',[0,0,1],'linewidth',0.8); 
                    end
                    
                    % ���Ʊ߽�
                    if (neu_burst(j,1) >= start_time & neu_burst(j,2) <= end_time)
                        plot([neu_burst(j,1),neu_burst(j,1)],[i-1,i],'Color',[0.5,0.5,0.5],'linewidth',0.8); 
                        plot([neu_burst(j,2),neu_burst(j,2)],[i-1,i],'Color',[0.5,0.5,0.5],'linewidth',0.8); 
                    end
                    
                end
                
                % 2. ������ע��ʼ�߽�.               
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
                
                set(gca,'xtick',[],'ytick',[]); % ȡ������
                set(gca,'Visible','off'); % ȡ���߿�
%                 set(gca,'XLim',[0 10]);
                hold on
         end
    end
    % print(gcf,'E:\AAAProjects\Matlab\save\SWW-5MINN.jpg','-r600','-djpeg')%����·��
end