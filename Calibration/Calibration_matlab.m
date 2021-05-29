clear all;close all;clc;
%% Importing data

[fileName, path] = uigetfile('*.*','Select raw spectrum data.','MultiSelect', 'on');
dataSize=length(fileName);
FileName=fullfile(path,fileName);
name = fileName{1}(1:length(fileName{1})-1);
for i=1:dataSize
    clc;
    disp(["Importing data: " num2str((i/dataSize)*100) "% - " fullfile(path,num2str(i))]);
    spec(i,:,:)=dlmread(fullfile(path, [name num2str(i)]), ",");
end
%% Raman Shift Conversion and Calibration

RSspec=RamanShiftConverter(dataSize,spec);
[Calx,CalInt]=AxisCorr(dataSize,RSspec);Calx=Calx(1,:);
%% Cutting

start = find(Calx == 0);
stop = find(Calx == 2300);

CalInt = CalInt(:,start:stop);
Calx = Calx(start:stop);
%% Plotting

plot(Calx,CalInt);
xlabel('Raman Shift (cm^{-1})','FontSize',13)
ylabel('Normalized Intensity (a.u.)','FontSize',13)
box on;
set(gca,'FontSize',13,'LineWidth',2);
set(gcf,'renderer','painters');
%% Save data
mkdir(path,'RAW');
pathRaw = fullfile(path,'RAW/');
for i=1:dataSize
    movefile(FileName{i},pathRaw)
end

save(fullfile(path,'CAL.mat'),'Calx','CalInt')
writematrix([Calx; CalInt], fullfile(path,'CAL.csv'))
%% Alarm

for i=1:3
    sound(sin(1:10000));
    pause(2)
end