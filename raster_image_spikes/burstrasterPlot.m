File=load('E:\AAAProjects\Matlab\trash\12-23-1-before-10minspon.mat');
Names=fieldnames(File)
[BurstData] = xlsread('E:\AAAProjects\Matlab\trash\1-before-spon10min_Burst.xlsx');%所有通道识别的爆发数据
%分拣出每个电极的爆发开始和结束时间
[NetworkBurstData]=csvread('E:\AAAProjects\Matlab\trash\12-23-beforeSpon-Burst_TimeArray.csv')
NB_start=NetworkBurstData(:,1)
NB_end=NetworkBurstData(:,2)
before_NetBurst_start_time=NB_start(0<NB_start& NB_end<10)
before_NetBurst_end_time=NB_end(0<NB_end & NB_end<10)
nummm = 0;
for i=1:length(Names)
    nummm = nummm + 1;
    rowNames=Names{i,1};
    Data=extractfield(File,rowNames)%1个电极对应的数据 
    SpikeData=Data(0<Data & Data<10)%选取每个电极前10s的spike数据
    Ele_Label=rowNames(20:21)%电极标签
    rowNum=(str2num(Ele_Label(1))-1)*8+str2num(Ele_Label(2))%绘制光栅图在第几行
    burst_start=BurstData(:,6*(i-1)+1)
    burst_end=BurstData(:,6*(i-1)+2)
    burst_time=[]
    before_burst_start_time=burst_start(0<burst_start & burst_start<10)%前10s的爆发开始时间点
    before_burst_end_time=burst_end(0<burst_end & burst_end<10)%前10s的爆发结束时间点
    spike_num=0
        for f=1:length(SpikeData)
            subplot(64,1,rowNum)
            if length(before_burst_start_time)~=0
                burst_num=0
                for spike_in_burst=1:length(before_burst_start_time)
                    if SpikeData(f)>=before_burst_start_time(spike_in_burst)&SpikeData(f)<=before_burst_end_time(spike_in_burst)
                       burst_num=burst_num+1
                       spike_num=spike_num+1
                    else
                        burst_num=burst_num+0
                    end
                end
                if burst_num==1
                     plot([SpikeData(f),SpikeData(f)],[i-1,i],'Color',[0,0,1],'linewidth',0.8)%可更改颜色和粗细[0.067,0.443,0.705]
                else
                        plot([SpikeData(f),SpikeData(f)],[i-1,i],'Color',[0,0,0],'linewidth',0.8)%可更改颜色和粗细[0.067,0.443,0.705]
                end
                set(gca,'xtick',[],'ytick',[])%取出坐标
                set(gca,'Visible','off')%取出边框
                hold on
            else
                   plot([SpikeData(f),SpikeData(f)],[i-1,i],'Color',[0,0,0],'linewidth',0.8)%可更改颜色和粗细[0.067,0.443,0.705]
            end
                set(gca,'xtick',[],'ytick',[])%取出坐标
                set(gca,'Visible','off')%取出边框
                hold on  
        end
        hold on
    
end 
 hold on
 for nb=1:length(before_NetBurst_start_time)
        x=[before_NetBurst_start_time(nb),before_NetBurst_start_time(nb)]
        y=[1,64]
        plot(x,y,'r-')
        hold on
        x1=[before_NetBurst_end_time(nb),before_NetBurst_end_time(nb)]
        y1=[1,64]
        plot(x1,y1,'r-')
        hold on 
 end
% print(gcf,'C:\Users\wwmong\Desktop\脑类器官光栅图\SWW-5MIN.jpg','-r600','-djpeg')%保存路径