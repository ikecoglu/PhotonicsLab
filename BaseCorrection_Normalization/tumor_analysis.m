clear all;close all;clc;
%% Single cell line base
basePoints=[670, 702, 790, 953, 1281, 1338, 1359, 1380, 1399, 1416, 1429, 1543, 1620, 1923, 2050, 2139, 2247, 2300];
[cal,fileName,pathName]=DataRead();%reads calibrated data.
[camF, camP] = uigetfile('.txt', 'MultiSelect', 'On');
for i = 1:length(camF)
    a = dlmread(fullfile(camP,camF{i}));
    camY(:,i) = a(:,2);
end
meanC = mean(camY,2);
Calx=cal(1,:,1);
CalInt=cal(:,:,2)-meanC';
dataSize=size(CalInt,1);
for i = 1:dataSize
    CalInt(i,:) = sgolayfilt(CalInt(i,:), 3,21);
end
[BCInt]=linear_base(basePoints,Calx,CalInt);
NormInt=normalization(BCInt);
%%
saveData(dataSize,fileName,pathName,Calx,BCInt,NormInt);