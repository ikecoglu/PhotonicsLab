clear all;clc;close all;
%% Cutting interval

StartFinish=[0, 2300];
%% importing data
[fileName, pathName] = uigetfile('*.*','Select data.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    spec(i,:,:)=dlmread(FileName{1,i,:},"",14,0);
end
%% Raman Shift Conversion and Calibration

RSspec=RamanShiftConverter(dataSize,spec);
[Sx,SInt]=AxisCorr(dataSize,RSspec);
%% Cutting

Calx=Sx(1,find(Sx(1,:)==min(StartFinish)):find(Sx(1,:)==max(StartFinish)));
CalInt=SInt(:,find(Sx(1,:)==min(StartFinish)):find(Sx(1,:)==max(StartFinish)));
%% Plotting

figure
set(gcf,'renderer','painters');
for i=1:dataSize
    plot(Calx,CalInt(i,:));
    hold on;
end
%% Save data

up = strfind(pathName,filesep);
pathName = pathName(1:up(end-1)-1);

% path=uigetdir(pathName,'Select where to save calibrated data.');
path=pathName;

mkdir(path,'CAL');
PathCAL=strcat(path,'/CAL/');
for i=1:dataSize
    clc;
    disp(strcat("Saving data: ",int2str((i/dataSize)*100),"%"));
    M(:,1)=Calx;
    M(:,2)=CalInt(i,:);
    dlmwrite(fullfile(PathCAL,fileName{i}),M);
end
%% Alarm

for i=1:3
    sound(sin(1:10000));
    pause(2)
end