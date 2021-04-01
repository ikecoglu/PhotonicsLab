clear all;close all;clc;
%% Data import
[cal,fileName,pathName]=DataRead();%reads calibrated data.
dataSize=size(cal,1);
Calx=cal(1,:,1);
s = cal(:,:,2);
CalInt = [];
for i = 1:dataSize
    CalInt(i,:) = sgolayfilt(s(i,:), 3,21);
end
%% Analysis
close all;clc;
basePoints = [670,680,733,769,945,1091,1204,1410,1548,1670,1790,1858,1918,2048,2096,2179,2300];
figure,plot(Calx,CalInt);hold on;
[y,BCInt] = base(dataSize,basePoints,Calx,CalInt);
plot(Calx,y);title("CAL");
figure,plot(Calx,BCInt);title("BC");
NormInt=normalization(BCInt);
figure,plot(Calx,NormInt);title("NORM");
%% Save data
saveData(dataSize,fileName,pathName,Calx,BCInt,NormInt);