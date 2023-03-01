clc;
clear all;
close all;
%本程序用于从burst一次结果中发掘全局burst并绘制爆发时间顺序图像

tic;
cd 'H:\graducatedata\20201111\circle\1\spon1.2\middleresult';
matlist = dir('*.mat');
namelist = {matlist.name}';
len = length(namelist);

for i = 1:len
    filename = ['H:\graducatedata\20201111\circle\1\spon1.2\middleresult\',namelist{i}];
    bursts = load(filename);
    burst = getfield(bursts,'burst');
    [m,n] = size(burst);
    burstinf = [];
 21-K
    
    for j = 1:m
        for k = 1:n/3
            if burst(j,3*k) == 0 
                continue;
            else
            burstinf(numofburst,1:2) = burst(j,3*k-2:3*k-1);
            burstinf(numofburst,3) = mean(burst(j,3*k-2:3*k-1));
            burstinf(numofburst,4) = j;
            numofburst = numofburst+1;
            end
        end
    end
    
    infsort = sortrows(burstinf,3);
    centre = infsort(:,3);
    
    bias = [];
    for l = 1:1:length(centre)-1
        bias(l) = centre(l+1)-centre(l);
    end
    
    biasplus = [];
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
    pop = [];
    point = [];
    for p = 1:length(biasplus)
        if ispop==0 && biasplus(p)==1
            ispop = 1;
            popnumber = 1;
            popstart = centre(p);
            startpoint = p;
        end
        
        if ispop==1 && biasplus(p)==1
            popnumber = popnumber+1;
        end
        
        if ispop==1 && biasplus(p)==0 && popnumber<700
            ispop = 0;
            popnumber = 0;
            popstart = 0;
        end
            
        if ispop==1 && biasplus(p)==0 && popnumber>700
            ispop = 0;
            popend = centre(p);
            endpoint = p;
            pop(whichpop,1) = popstart;
            pop(whichpop,2) = popend;
            point(whichpop,1) = startpoint;
            point(whichpop,2) = endpoint;
            whichpop = whichpop+1;
            popnumber = 0;
        end
    end
    
    for q = 1:whichpop-1
        current = [];
        start = point(q,1);
        endd = point(q,2);
        current = infsort(start:endd,:);
        currentsort = sortrows(current,1);
        marker = zeros(1,4096);
        meaflag = 1;
        measort = [];
        for r = 1:length(currentsort)
            if marker(currentsort(r,4)) == 1
                continue;
            else
                measort(meaflag,:) = currentsort(r,:);
                meaflag = meaflag+1;
                marker(currentsort(r,4)) = 1;
            end
        end
        measortclear = measort(:,1);


        med = median(measortclear);
        downboundary = med-0.025;
        upboundary = med+0.025;
        flag1 = 1;
        measortselected = [];
        for s = 1:length(measortclear)
            if measortclear(s)<upboundary && measortclear(s)>downboundary
                measortselected(flag1,:) = measort(s,:);
                flag1 = flag1+1;
            else
                continue;
            end
        end
        
        nn = ceil(length(measortselected(:,1))/4);
        origin = measortselected(1:10,4);
        firstround = measortselected(11:11+nn,4);
        secondround = measortselected(12+nn:12+2*nn,4);
        thirdround = measortselected(13+2*nn:13+3*nn,4);
        fourstround = measortselected(14+3*nn:end,:);
        
        mea = zeros(64,64);
        for a = 1:64
            for b = 1:64
                spot = (a-1)*64+b;
                if ismember(spot,measort(:,4))
                    mm = find(measort(:,4)==spot);
                    mea(a,b) = measortclear(mm);
                else
                    continue;
                end
            end
        end
        
        
        meaplot = zeros(64,64);
        for c = 1:64
            for d = 1:64
                spots = (c-1)*64+d;
                if find(origin==spots)
                    meaplot(c,d) = 5;
                elseif find(firstround==spots)
                    meaplot(c,d) = 4;
                elseif find(secondround==spots)
                    meaplot(c,d) = 3;
                elseif find(thirdround==spots)
                    meaplot(c,d) = 2;
                elseif find(fourstround==spots)
                    meaplot(c,d) = 1;
                end
            end
        end
        savename1 = ['H:\graducatedata\20201111\circle\1\spon1.2\result\',namelist{i}(1:5),'-',num2str(q),'-time'];
        savename2 = ['H:\graducatedata\20201111\circle\1\spon1.2\result\',namelist{i}(1:5),'-',num2str(q),'-grade'];
        save(savename1,'mea');
        save(savename2,'meaplot');
%         figure(1)
%         t = 1:1:length(measortclear);
%         t2 = 1:1:length(measortselected(:,1));
%         plot(t,measortclear);
%         hold on
%         plot(t2,measortselected(:,1),'Linewidth',2);
%         hold off
%         
        
    end
    
end
toc;
