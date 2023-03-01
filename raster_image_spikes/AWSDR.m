%计算时间窗时间（10ms)-2min数据
% Timearray=zeros(1)
% allEleSpike=zeros(1,1)%统计所有电极每个时间窗内的spike个数
% for b=1:1200%bin=100ms
%     addTime=0.1*b
%     Timearray(end+1)=addTime
% end
clc
clear
load('E:\AAAProjects\Matlab\data\Timearray100ms_30s.mat');%Timearray%所有时间窗的数值点（0，0.1....120）
load('E:\AAAProjects\Matlab\data\before-spon-10min.mat');

data=whos
datalength={data.size}%spike个数
datalength(60)=[] % 把电极给去了 time时间戳还在 60为time数据
eleName={data.name}%电极名
eleName(60)=[]
allEleSpike=zeros(1,length(Timearray)-1)%所有电极每个窗的spike个数
% for i=1:length(eleName)
for i=1:length(eleName)
    rowNames=eleName{1,i};
    Data=evalin('base',rowNames)%读取每个电极所有spike数据
    TotalSpike=zeros(1)%记录每个电极下当前时间戳的spike总数
        for ti=1:length(Timearray)
            if ti+1<=length(Timearray)
               spikenum=length(Data(Data>=Timearray(ti)&Data<=Timearray(ti+1)))%在这个时间段内有几个spike
               TotalSpike(end+1)=spikenum%统计300个窗的spike
            end
            spikenum=0
        end
        TotalSpike(1)=[]
        allEleSpike(i,:)=TotalSpike
end

% % allEleSpike 中值为0的元素不显示.
% a=find(allEleSpike==0);
% allEleSpike(a)=1;

% % 绘制热图 颜色模式为 jet 并设置 NAN 为透明色.
% h = heatmap(allEleSpike);
% colormap(jet)

% 去除横纵坐标

% ax = gca;
% ax.XDisplayLabels = nan(size(ax.XDisplayData));
% ax.YDisplayLabels = nan(size(ax.YDisplayData));

set(gca,'YLim',[0 100])
set(gca,'ytick',[])%取出坐标
set(gca,'Visible','off')

colnum=zeros(1,length(allEleSpike))
for r=1:length(allEleSpike)
    colnum(r)=sum(allEleSpike(:,r))
end

avergecolnum=colnum*10
plot(colnum,'k','linewidth',1)



% zprint(gcf,'E:\AAAProjects\Matlab\save\SWW-5MINN-30ms.jpg','-r600','-djpeg')%保存路径
% averageSpike=sum(allEleSpike,1)
% averageSpikeColmun=averageSpike/6000
% % 



