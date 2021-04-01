clear all;close all;clc;
%% Single cell line base
basePoints=[670, 685, 768, 909, 948, 970, 1088, 1205, 1401, 1576, 1628, 1720, 1767, 1800];
[cal,fileName,pathName]=DataRead();%reads calibrated data.
% Calx=670:1800;
Calx=cal(1,:,1);
CalInt=cal(:,:,2);
dataSize=size(CalInt,1);
%% Mixed sample base
basePoints = [670,764,950,1075,1207,1415,1575,1717,1760,1800];
[cal,fileName,pathName]=DataRead();%reads calibrated data.
dataSize=size(cal,1);
Calx=670:1800;
s = cal(:,:,2);
CalInt = [];
for i = 1:dataSize
    CalInt(i,:) = sgolayfilt(CalInt(i,:), 3,21);
end
%%
[BCInt]=linear_base(basePoints,Calx,CalInt);
NormInt=normalization(BCInt);
saveData(dataSize,fileName,pathName,Calx,BCInt,NormInt);