%����ʱ�䴰ʱ�䣨10ms)-2min����
% Timearray=zeros(1)
% allEleSpike=zeros(1,1)%ͳ�����е缫ÿ��ʱ�䴰�ڵ�spike����
% for b=1:1200%bin=100ms
%     addTime=0.1*b
%     Timearray(end+1)=addTime
% end
clc
clear
load('E:\AAAProjects\Matlab\data\Timearray100ms_30s.mat');%Timearray%����ʱ�䴰����ֵ�㣨0��0.1....120��
load('E:\AAAProjects\Matlab\data\before-spon-10min.mat');

data=whos
datalength={data.size}%spike����
datalength(60)=[] % �ѵ缫��ȥ�� timeʱ������� 60Ϊtime����
eleName={data.name}%�缫��
eleName(60)=[]
allEleSpike=zeros(1,length(Timearray)-1)%���е缫ÿ������spike����
% for i=1:length(eleName)
for i=1:length(eleName)
    rowNames=eleName{1,i};
    Data=evalin('base',rowNames)%��ȡÿ���缫����spike����
    TotalSpike=zeros(1)%��¼ÿ���缫�µ�ǰʱ�����spike����
        for ti=1:length(Timearray)
            if ti+1<=length(Timearray)
               spikenum=length(Data(Data>=Timearray(ti)&Data<=Timearray(ti+1)))%�����ʱ������м���spike
               TotalSpike(end+1)=spikenum%ͳ��300������spike
            end
            spikenum=0
        end
        TotalSpike(1)=[]
        allEleSpike(i,:)=TotalSpike
end

% % allEleSpike ��ֵΪ0��Ԫ�ز���ʾ.
% a=find(allEleSpike==0);
% allEleSpike(a)=1;

% % ������ͼ ��ɫģʽΪ jet ������ NAN Ϊ͸��ɫ.
% h = heatmap(allEleSpike);
% colormap(jet)

% ȥ����������

% ax = gca;
% ax.XDisplayLabels = nan(size(ax.XDisplayData));
% ax.YDisplayLabels = nan(size(ax.YDisplayData));

set(gca,'YLim',[0 100])
set(gca,'ytick',[])%ȡ������
set(gca,'Visible','off')

colnum=zeros(1,length(allEleSpike))
for r=1:length(allEleSpike)
    colnum(r)=sum(allEleSpike(:,r))
end

avergecolnum=colnum*10
plot(colnum,'k','linewidth',1)



% zprint(gcf,'E:\AAAProjects\Matlab\save\SWW-5MINN-30ms.jpg','-r600','-djpeg')%����·��
% averageSpike=sum(allEleSpike,1)
% averageSpikeColmun=averageSpike/6000
% % 



