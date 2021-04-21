clear all;clc;close all;
%% Fixed Basepoints
%only determines interval to cut so only the first and the last ones are
%important.
basePoints=[0,680,733,769,945,1091,1204,1410,1548,1670,1790,1858,1918,2048,2096,2179,2300];
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

spec=RamanShiftConverter(dataSize,spec);
[Sx,SInt]=AxisCorr(dataSize,spec);

CalInt=SInt(:,find(Sx(1,:)==min(basePoints)):find(Sx(1,:)==max(basePoints)));
Calx=Sx(1,find(Sx(1,:)==min(basePoints)):find(Sx(1,:)==max(basePoints)));

set(gcf,'renderer','painters');
for i=1:dataSize
plot(Calx,CalInt(i,:));
hold on;
end
%% save data
up = strfind(pathName,filesep);
pathName = pathName(1:up(end-1)-1);
path=uigetdir(pathName,'Select where to save calibrated data.');
mkdir(path,'CAL');
PathCAL=strcat(path,'/CAL/');
for i=1:dataSize
    clc;
    disp(strcat("Saving data: ",int2str((i/dataSize)*100),"%"));
    M(:,1)=Calx;
    M(:,2)=CalInt(i,:);
    dlmwrite(fullfile(PathCAL,fileName{i}),M);
end