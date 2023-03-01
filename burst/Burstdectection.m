clc;
clear all;
close all;
%本程序用于从burst一次结果中发掘全局burst

tic;
cd 'H:\graducatedata\20201111\circle\1\spon1.2\middleresult';
matlist = dir('*.mat');
namelist = {matlist.name}';
len = length(namelist);
result = zeros(8,3);


for i = 1:len
    filename = ['H:\graducatedata\20201111\circle\1\spon1.2\middleresult\',namelist{i}];
    bursts = load(filename);
    burst = getfield(bursts,'burst');
    [m,n] = size(burst);
    jvlei = [];
    bias = [];
    biasplus = [];
    redetect =zeros(1,37000);
    indexx = [];
    resultf = [];
    point = [];
    pop = [];
    
    flag = 1;
    for j = 1:m
        for k = 1:n/3
          centre(j,k) = (burst(j,3*k-1)+burst(j,3*k-2))/2;
          spikeinburst(j,k) = burst(j,3*k);
          during(j,k) = burst(j,3*k-1)-burst(j,3*k-2);
          if centre(j,k) ~= 0
              jvlei(flag) = centre(j,k);
              flag = flag+1;
          end
        end
    end
    jvlei = sort(jvlei);
    
    for l = 1:length(jvlei)-1
        bias(l) = jvlei(l+1)-jvlei(l);
    end
    
    for o = 1:length(bias)
        if bias(o) <0.01
          biasplus(o) = 1;
        else
          biasplus(o) = 0;
        end
    end
    
    ispop = 0;
    popnumber = 0;
    popstart = 0;
    popend = 0;
    whichpop = 1;
    for p = 1:length(biasplus)
        if ispop==0 && biasplus(p)==1
            ispop = 1;
            popnumber = 1;
            popstart = jvlei(p);
            startpoint = p;
        end
        
        if ispop==1 && biasplus(p)==1
            popnumber = popnumber+1;
        end
        
        if ispop==1 && biasplus(p)==0 && popnumber<800
            ispop = 0;
            popnumber = 0;
            popstart = 0;
        end
            
        if ispop==1 && biasplus(p)==0 && popnumber>800
            ispop = 0;
            popend = jvlei(p);
            endpoint = p;
            pop(i,whichpop) = popstart;
            pop(i,whichpop+1) = popend;
            point(i,whichpop) = startpoint;
            point(i,whichpop+1) = endpoint;
            whichpop = whichpop+2;
            popnumber = 0;
        end
    end
    
    if isempty(pop)
        continue;
    end
    pointcurrent = point(i,:);
    popcurrent = pop(i,:);
    
    [m1,n1] = size(centre);
    
    a = 1;
    b = 1;
    for q=1:length(pointcurrent)
        if pointcurrent(q)~=0
            if mod(q, 2) == 1
                restart = pointcurrent(q);
                censtart = popcurrent(q);
            else
                reend = pointcurrent(q);
                cenend = popcurrent(q);
                redetect(restart:reend) = 1;
                for r = 1:m1
                    for s = 1:n1
                        if centre(r,s)>censtart && centre(r,s)<cenend
                            indexx(a,b:b+1) = [r,s];
                            a = a+1;
                        end
                    end
                end
                b = b+2;
                a = 1;
            end
        end
    end
    
    [m2 n2] = size(indexx);
    for u = 1:m2
        for v = 1:2:(n2-1)
            if indexx(u,v) ~= 0
                row = indexx(u,v);
                col = indexx(u,v+1);
                resultf(u,v) = during(row,col);
                resultf(u,v+1) = spikeinburst(row,col);
            end
        end
    end
    
    [m3,n3] = size(resultf);
    result(i,1) = n3/2;
    jishu = 0;
    shijian = 0;
    geshu = 0;
    for w = 1:m3
        for x = 1:2:(n3-1)
            if resultf(w,x) ~= 0
                jishu = jishu+1;
                shijian = shijian+resultf(w,x);
                geshu = geshu+resultf(w,x+1);
            end
        end
    end
    result(i,2) = shijian/jishu;
    result(i,3) = geshu/jishu;
    
    t = 1:1:length(jvlei);
    t1 = 1:1:length(bias);
    t2 = 1:1:length(redetect);
    eval(['figure(',num2str(i),')']);
    subplot(411)
    plot(t,jvlei);
    xlabel('爆发的次数');
    ylabel('中心点时间/s');
    subplot(412)
    plot(t1,bias);
    xlabel('爆发的次数');
    ylabel('相邻中心点时间差/s');
    axis([-100 length(bias)+100 -0.01 0.06]);
    subplot(413)
    plot(t1,biasplus);
    xlabel('爆发的次数');
    ylabel('一次归一化');
    axis([-100 length(bias)+100 -0.5 1.5]);
    subplot(414)
    plot(t2,redetect);
    xlabel('爆发的次数');
    ylabel('二次归一化');
    axis([-100 length(bias)+100 -0.5 1.5]);
end
toc;
