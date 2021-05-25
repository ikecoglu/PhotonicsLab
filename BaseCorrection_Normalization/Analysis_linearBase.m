clear all;close all;clc;
%% Single cell line base
basePoints=[250,259, 463, 679, 902, 1157, 1273, 1601, 1725, 2041, 2300];
[cal,fileName,pathName]=DataRead();%reads calibrated data.
Calx=cal(1,:,1);
CalInt=cal(:,find(Calx==basePoints(1)):find(Calx==basePoints(end)),2);
Calx=Calx(find(Calx==basePoints(1)):find(Calx==basePoints(end)));
dataSize=size(CalInt,1);
%% Sgolay fit
% basePoints = [670,764,950,1075,1207,1415,1575,1717,1760,1800];
% [cal,fileName,pathName]=DataRead();%reads calibrated data.
% dataSize=size(cal,1);
% s = cal(:,:,2);
% CalInt = [];
% for i = 1:dataSize
%     CalInt(i,:) = sgolayfilt(CalInt(i,:), 3,21);
% end
%% Base correction and Normalization
[BCInt]=linear_base(basePoints,Calx,CalInt);
NormInt=normalization(BCInt);
%% Save
saveData(fileName,pathName,Calx,BCInt,NormInt);