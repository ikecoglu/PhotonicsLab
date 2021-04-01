clear all;clc;close all;
%% Fixed Basepoints
basePoints=[670,680,733,769,945,1091,1204,1410,1548,1670,1790,1858,1918,2048,2096,2179,2300];
%% importing data 
[fileName, pathName] = uigetfile('*.*','Select raw spectrum data.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    spec(i,:,:)=dlmread(FileName{1,i,:},",");
end
%% calibrate data
% dataSize = 5041;

spec=RamanShiftConverter(dataSize,spec);
[Sx,SInt]=AxisCorr(dataSize,spec);

for i=1:dataSize
    clc;
    disp(strcat("Cutting data: ",int2str((i/dataSize)*100),"%"));
    CalInt=SInt(:,find(Sx(i,:)==min(basePoints)):find(Sx(i,:)==max(basePoints)));
    Calx=Sx(:,find(Sx(i,:)==min(basePoints)):find(Sx(i,:)==max(basePoints)));
end
Calx=Calx(1,:);
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