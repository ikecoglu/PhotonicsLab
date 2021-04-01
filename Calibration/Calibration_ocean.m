clear all;clc;close all;
%% Fixed Basepoints
basePoints=[0, 670, 685, 768, 909, 948, 970, 1088, 1205, 1401, 1576, 1628, 1720, 1767, 1800,2300];
%% importing data
[fileName, pathName] = uigetfile('*.*','Select data.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    spec(i,:,:)=dlmread(FileName{1,i,:},"",14,0);
end
%% calibrate data
spec=RamanShiftConverter(dataSize,spec);
[Sx,SInt]=AxisCorr(dataSize,spec);
Calx=Sx(1,find(Sx(1,:)==min(basePoints)):find(Sx(1,:)==max(basePoints)));
for i=1:dataSize
    CalInt=SInt(:,find(Sx(i,:)==min(basePoints)):find(Sx(i,:)==max(basePoints)));
end
for i=1:dataSize
plot(Calx,CalInt(i,:));
hold on;
end
%% save data
up = strfind(pathName,filesep);
pathName = pathName(1:up(end-1)-1);
path=uigetdir(pathName,'Select where to save calibrated data.');
mkdir(path,'CAL');
PathCAL=strcat(path,'\CAL\');
for i=1:dataSize
    clc;
    disp(strcat("Saving data: ",int2str((i/dataSize)*100),"%"));
    M(:,1)=Calx;
    M(:,2)=CalInt(i,:);
    dlmwrite(fullfile(PathCAL,fileName{i}),M);
end