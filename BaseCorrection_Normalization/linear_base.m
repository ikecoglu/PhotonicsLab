function [BCInt] = linear_base(basePoints,Calx,CalInt)
for i=1:size(basePoints,2)
    indx(i)=find(Calx==basePoints(i));
end
figure
dataSize = size(CalInt,1);
for k= 1:dataSize
    clc;
    disp(strcat("Base correction: ",int2str((k/dataSize)*100),"%"));
    plot(Calx,CalInt(k,:));
    hold on
    for i=1:size(basePoints,2)-1
        n = indx(i+1)-indx(i)+1;
        x = linspace(basePoints(i),basePoints(i+1),n);
        y = linspace(CalInt(k,indx(i)),CalInt(k,indx(i+1)),n);
        line(x,y);
        BCInt(k,indx(i):indx(i+1)) = CalInt(k,indx(i):indx(i+1)) - y;
    end
end
minv = round(min(min(CalInt)));
maxv = round(max(max(CalInt)));
for i = 1:size(basePoints,2)
plot(repmat([basePoints(i)],1,maxv-minv+1),minv:maxv,'k--');
end
figure
plot(Calx,BCInt);
end