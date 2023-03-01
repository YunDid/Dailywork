% 
% V2 = allEleSpike;
% a=find(V2==0);
% V2(a)=1;
% [W2,H2,errs2,varout2] = nmf_alg(V2,10,'alg',@nmf_kl,)



sum1 = sum(allEleSpike,2);
V = allEleSpike;
V(58,:) = [];
V(51,:) = [];
V(21,:) = [];
sum2 = sum(V,2);

[W,H,errs] = nmf_alg(V,10,'alg',@nmf_kl_con,'niter', 500)
V2 = W * H;
% 扩充数组. 其余元素补0.
W1 = padarray(W,8,0,'post')

heatmap(H);
colormap(jet)

H_min = H(:,77:80);
% t = tiledlayout(2,1);
% nexttile;
% heatmap(H);
% nexttile;
heatmap(H_min);
colormap(jet)

% 序列排序
t = tiledlayout(10,1);
index1 = [];
for i = 1:10
    sub = H_min(i,:);
    index = find(sub==max(sub));
    index1 = [index1,index];
    nexttile
    plot(H_min(i,:));
    title("SPP"+ i)
end

sort_arr = find(max(H_min,2))


% t = tiledlayout(2,1);
% 
% % a=find(H==0);
% % H(a)=NaN;
% 
% nexttile
% h = heatmap(H);
% colormap(jet)
% 
% nexttile
% plot(colnum,'k','linewidth',1)


% 
% 去除横纵坐标
% 
% ax = gca;
% ax.XDisplayLabels = nan(size(ax.XDisplayData));
% ax.YDisplayLabels = nan(size(ax.YDisplayData));

% 绘制热图 颜色模式为 jet 并设置 NAN 为透明色.
% t = tiledlayout(4,4);
% title(t,"SPP#")
% for i = 1 : 10
%     vec = W1(:,i);
%     vec1 = reshape(vec,[8,8])
%         
%     nexttile
%     h = heatmap(vec1);
%     colormap(jet)
%     title("SPP"+ i)
%    
% end
% X = W * H;
% h = heatmap(H);
% colormap(jet)
% % 去除横纵坐标
% 
% ax = gca;
% ax.XDisplayLabels = nan(size(ax.XDisplayData));
% ax.YDisplayLabels = nan(size(ax.YDisplayData));