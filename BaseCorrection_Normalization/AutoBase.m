clear all;close all;clc;
%% Single cell line base
basePoints=[670, 702, 790, 953, 1281, 1338, 1359, 1380, 1399, 1416, 1429, 1543, 1620, 1923, 2050, 2139, 2247, 2300];
[cal,fileName,pathName]=DataRead();%reads calibrated data.
Calx=cal(1,:,1);
CalInt=cal(:,:,2);
dataSize=size(CalInt,1);
for i = 1:dataSize
    CalInt(i,:) = sgolayfilt(CalInt(i,:), 3,21);
end
%%
[BCInt]=linear_base(basePoints,Calx,CalInt);
NormInt=normalization(BCInt);
%%
% saveData(dataSize,fileName,pathName,Calx,BCInt,NormInt);
%%
k=20;
dy=gradient(CalInt(k,:))./gradient(Calx);

plot(Calx,CalInt(k,:))
hold on
[~,l]=findpeaks(-CalInt(k,:),Calx);
for i=1:size(l,2)
    ind(i)=find(Calx==l(i),1);
end
mindat=round(min(CalInt(k,:)),-3);
for i=1:size(l,2)
    plot([l(i),l(i)],[mindat CalInt(k,find(Calx==l(i),1))])
end
yip=interp1(l,CalInt(k,ind),Calx,"spline");
for i=1:size(l,2)-1
    n = l(i+1)-l(i)+1;
    x = linspace(l(i),l(i+1),n);
    y = linspace(CalInt(k,find(Calx==l(i),1)),CalInt(k,find(Calx==l(i+1),1)),n);
    line(x,y);
    %         BCInt(k,indx(i):indx(i+1)) = CalInt(k,indx(i):indx(i+1)) - y;
end
plot(Calx,yip)
clear i k x y