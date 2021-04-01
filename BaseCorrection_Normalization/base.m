function [y,BCInt] = base(dataSize,basePoints,Calx,CalInt)
for i=1:size(basePoints,2)
    RSx(i)=find(Calx==basePoints(i));
end
for i= 1:dataSize
    clc;
    disp(strcat("Base correction: ",int2str((i/dataSize)*100),"%"));
    y(i,:)=interp1(basePoints,CalInt(i,RSx),Calx,"spline");
    for k=1:size(CalInt,2)
        BCInt(i,k)=CalInt(i,k)-y(i,k);
    end
end
minv = round(min(min(CalInt)));
maxv = round(max(max(CalInt)));
for i = 1:size(basePoints,2)
plot(repmat([basePoints(i)],1,maxv-minv+1),minv:maxv,'k--');
end