%% ht1
figure
sgtitle('ht1')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht1(2:end,i));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht1(1,i))
end
figure
sgtitle('ht1')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht1(2:end,i+4));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht1(1,i+4))
end
figure
dist = pdist(ht1(2:end,i+4));
link = linkage(dist);
dendrogram(link,0)
title(strcat('ht1',{' '},num2str(ht1(1,9))))
%% ht10
figure 
sgtitle('ht10')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht10(2:end,i));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht10(1,i))
end
figure
sgtitle('ht10')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht10(2:end,i+4));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht10(1,i+4))
end
figure
dist = pdist(ht10(2:end,i+4));
link = linkage(dist);
dendrogram(link,0)
title(strcat('ht10',{' '},num2str(ht10(1,9))))
%% ht25
figure
sgtitle('ht25')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht25(2:end,i));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht25(1,i))
end
figure
sgtitle('ht25')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht25(2:end,i+4));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht25(1,i+4))
end
figure
dist = pdist(ht25(2:end,i+4));
link = linkage(dist);
dendrogram(link,0)
title(strcat('ht25',{' '},num2str(ht25(1,9))))
%% ht50
figure
sgtitle('ht50')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht50(2:end,i));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht50(1,i))
end
figure
sgtitle('ht50')
for i=1:4
    subplot(2,2,i)
    dist = pdist(ht50(2:end,i+4));
    link = linkage(dist);
    dendrogram(link,0)
    title(ht50(1,i+4))
end
figure
dist = pdist(ht50(2:end,i+4));
link = linkage(dist);
dendrogram(link,0)
title(strcat('ht50',{' '},num2str(ht50(1,9))))