%��դͼ��˼��%
%��һ������������
%�ڶ�������ȡ�������缫���
%���������жϵ缫����Ƿ��������缫��Χ�ڣ�������ڣ���plot(0),�����ж��Ƿ���spike����spike����ʱ����ƣ�����plot(0)
%'F:\����������\��һ��MCS����\spike\23\MEA3.mat'
%dataPath: ��������·��
%time��spikeʱ�䷶Χ��120=2min��
%savePath������ͼƬ·��
clc
clear
    dataPath='E:\AAAProjects\Matlab\data\before-spon-10min.mat'
    load(dataPath);
    time=120
    data=whos
    datalength={data.size}%spike����
    datalength(1)=[]
    eleName={data.name}%�缫��
    eleName(1)=[]
    elename=zeros(1)
    spikenum=zeros(1)
    for i=1:length(eleName)
        rowNames=eleName{1,i};
        if length(rowNames)>10
           eleIndex=rowNames(15:16)%�缫���
           elename(i)=str2num(eleIndex)
        end
    end
    spikeindex=[11,12,13,14,15,16,17,18,21,22,23,24,25,26,27,28,31,32,33,34,35,36,37,38,41,42,43,44,45,46,47,48,51,52,53,54,55,56,57,58,61,62,63,64,65,66,67,68,71,72,73,74,75,76,77,78,81,82,83,84,85,86,87,88]
    j=1
    allspikeNum=zeros(2,1)
    for i=1:length(spikeindex)%ѭ�����е缫���64��
    % for i=1:3 %ѭ�����е缫���64��    
        A=ismember(spikeindex(i),elename)%�жϵ缫�Ƿ�����spike��Χ��
        B=spikeindex(i)
        if A==0%����缫�Ų��������缫�����
           subplot(64,1,i)
           plot(0)
           set(gca,'XLim',[0 time]);
           set(gca,'Visible','off')%ȡ���߿�
        else
           singleName=['elec0001_adch_',num2str(B),'_nr']
           Data=evalin('base',singleName)%��ȡ�������̶����ֵ�����%1���缫��Ӧ������ 
           l=length(Data)
           if l==0
               subplot(64,1,i)
               plot(0)
               set(gca,'XLim',[0 time]);
               set(gca,'Visible','off')%ȡ���߿�
          else
               singleName=['elec0001_adch_',num2str(B),'_nr']
               Data=evalin('base',singleName)%��ȡ�������̶����ֵ�����%1���缫��Ӧ������ 
               subplot(64,1,i)
               Data=Data(Data<=time)%ʱ�䳤��
               for f=1:length(Data)
                    plot([Data(f),Data(f)],[0,0.5],'Color',[0,0,0],'linewidth',1)%�ɸ�����ɫ�ʹ�ϸ[0.067,0.443,0.705]
                    hold on
               end
               set(gca,'XLim',[0 time]);
               set(gca,'Visible','off')%ȡ���߿�
           end
        end
    end
    
    print(gcf,'E:\AAAProjects\Matlab\save\SWW-5MIN.jpg','-r600','-djpeg')%����·��
 %   savePath='E:\AAAProjects\Matlab\save'
 %  print(gcf,savePath,'.png','-r600','-djpeg')%����·��
