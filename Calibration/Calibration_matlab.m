clear all;close all;clc;
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
[Calx,CalInt]=AxisCorr(dataSize,RSspec);Calx=Calx(1,:);
%% Plotting

figure
for i=1:dataSize
    plot(Calx,CalInt(i,:));
    hold on;
end
xlabel('Raman Shift (cm^{-1})','FontSize',13)
ylabel('Normalized Intensity (a.u.)','FontSize',13)
box on;
set(gca,'FontSize',13,'LineWidth',2);
set(gcf,'renderer','painters');
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