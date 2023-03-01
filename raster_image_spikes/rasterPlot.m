%光栅图的思想%
%第一步：加载数据
%第二步：读取工作区电极标号
%第三步：判断电极标号是否在所属电极范围内，如果不在，则plot(0),否则判断是否有spike，有spike根据时间绘制，否则plot(0)
%'F:\课题四数据\第一批MCS数据\spike\23\MEA3.mat'
%dataPath: 加载数据路径
%time：spike时间范围（120=2min）
%savePath：保存图片路径
clc
clear
    dataPath='E:\AAAProjects\Matlab\data\before-spon-10min.mat'
    load(dataPath);
    time=120
    data=whos
    datalength={data.size}%spike个数
    datalength(1)=[]
    eleName={data.name}%电极名
    eleName(1)=[]
    elename=zeros(1)
    spikenum=zeros(1)
    for i=1:length(eleName)
        rowNames=eleName{1,i};
        if length(rowNames)>10
           eleIndex=rowNames(15:16)%电极标号
           elename(i)=str2num(eleIndex)
        end
    end
    spikeindex=[11,12,13,14,15,16,17,18,21,22,23,24,25,26,27,28,31,32,33,34,35,36,37,38,41,42,43,44,45,46,47,48,51,52,53,54,55,56,57,58,61,62,63,64,65,66,67,68,71,72,73,74,75,76,77,78,81,82,83,84,85,86,87,88]
    j=1
    allspikeNum=zeros(2,1)
    for i=1:length(spikeindex)%循环所有电极标号64个
    % for i=1:3 %循环所有电极标号64个    
        A=ismember(spikeindex(i),elename)%判断电极是否在有spike范围内
        B=spikeindex(i)
        if A==0%如果电极号不在所属电极标号中
           subplot(64,1,i)
           plot(0)
           set(gca,'XLim',[0 time]);
           set(gca,'Visible','off')%取出边框
        else
           singleName=['elec0001_adch_',num2str(B),'_nr']
           Data=evalin('base',singleName)%读取工作区固定名字的数据%1个电极对应的数据 
           l=length(Data)
           if l==0
               subplot(64,1,i)
               plot(0)
               set(gca,'XLim',[0 time]);
               set(gca,'Visible','off')%取出边框
          else
               singleName=['elec0001_adch_',num2str(B),'_nr']
               Data=evalin('base',singleName)%读取工作区固定名字的数据%1个电极对应的数据 
               subplot(64,1,i)
               Data=Data(Data<=time)%时间长度
               for f=1:length(Data)
                    plot([Data(f),Data(f)],[0,0.5],'Color',[0,0,0],'linewidth',1)%可更改颜色和粗细[0.067,0.443,0.705]
                    hold on
               end
               set(gca,'XLim',[0 time]);
               set(gca,'Visible','off')%取出边框
           end
        end
    end
    
    print(gcf,'E:\AAAProjects\Matlab\save\SWW-5MIN.jpg','-r600','-djpeg')%保存路径
 %   savePath='E:\AAAProjects\Matlab\save'
 %  print(gcf,savePath,'.png','-r600','-djpeg')%保存路径
