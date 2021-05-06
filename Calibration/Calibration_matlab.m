clear all;clc;close all;
%% Cutting interval

StartFinish=[0, 2300];
%% Importing data

[fileName, path] = uigetfile('*.*','Select raw spectrum data.','MultiSelect', 'on');
FileName=fullfile(path,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    spec(i,:,:)=dlmread(FileName{1,i,:},",");
end
%% Raman Shift Conversion and Calibration

RSspec=RamanShiftConverter(dataSize,spec);
[Sx,SInt]=AxisCorr(dataSize,RSspec);
%% Cutting

CalInt=SInt(:,find(Sx(1,:)==StartFinish(1)):find(Sx(1,:)==StartFinish(2)));
Calx=Sx(1,find(Sx(1,:)==StartFinish(1)):find(Sx(1,:)==StartFinish(2)));
%% Plotting

figure
set(gcf,'renderer','painters');
for i=1:dataSize
    plot(Calx,CalInt(i,:));
    hold on;
end
%% Save data
mkdir(path,'RAW');
pathRaw = strcat(path,'RAW/');
for i=1:dataSize
    movefile(FileName{i},pathRaw)
end

mkdir(path,'CAL');
pathCal=strcat(path,'CAL/');
for i=1:dataSize
    clc;
    disp(strcat("Saving data: ",int2str((i/dataSize)*100),"%"));
    M(:,1)=Calx;
    M(:,2)=CalInt(i,:);
    dlmwrite(fullfile(pathCal,fileName{i}),M);
end
%% Alarm

for i=1:3
    sound(sin(1:10000));
    pause(2)
end