clear all;close all; clc;
% This code uses 3 points to find and eliminate outliers
%% User input
Length=70; %legth of a side of scanned square. Unit is how many our step so actually legth/stepsize.
Point1=1269;%the raman shift that is going to be mapped in 3d plot.
Point2=1144;
Point3=1505;
dataSize=(Length+1)^2;
%% Reading data
%Data can be imported with a mat file. In this case name the data as "data"
%and skip this section.
[fileName, pathName] = uigetfile('*.*','Select data to map.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    data(i,:,:)=dlmread(FileName{1,i,:},",");
end
%% map1 - map of point1
% In order to try different tresholds, just change "trs" and rerun this
% section.
trs1=90;%HT:200/THP:90/HEC:150/MEF:440/HELA:220 These values are for BC data.
list1 = outlierFinderFunc(data,dataSize,Length,Point1,trs1);
%% map2 - map of point2
% In order to try different tresholds, just change "trs" and rerun this
% section.
trs2=30;%HT:70/THP:30/HEC:0/MEF:110/HELA:55 These values are for BC data.
list2 = outlierFinderFunc(data,dataSize,Length,Point2,trs2);
%% map3 - map of point3
% In order to try different tresholds, just change "trs" and rerun this
% section.
trs3=40;%HT:75/THP:40/HEC:75/MEF:180/HELA:100 These values are for BC data.
list3 = outlierFinderFunc(data,dataSize,Length,Point3,trs3);
%% map mixed outliers eliminated
list = tripleOutlierFinderFunc(data,dataSize,Length,Point1,Point2,Point3,trs1,trs2,trs3);