clear all; close all; clc;
%% importing data

[fileName, path] = uigetfile('*.txt*','Select data.','MultiSelect', 'on');
FileAdress = fullfile(path,fileName);
dataSize = length(FileAdress);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    spec(i,:,:) = dlmread(FileAdress{1,i,:},"",14,0);
end
%% Raman Shift Conversion and Calibration

RSspec = RamanShiftConverter(dataSize,spec);
[Calx,CalInt] = AxisCorr(dataSize,RSspec);Calx=Calx(1,:);
%% Cutting

start = find(Calx == 0);
stop = find(Calx == 2500);

CalInt = CalInt(:,start:stop);
Calx = Calx(start:stop);
%% Plotting

plot(Calx, CalInt);
xlabel('Raman Shift (cm^{-1})','FontSize',13)
ylabel('Raman Intensity (a.u.)','FontSize',13)
box on;
set(gca,'FontSize',13,'LineWidth',2);
set(gcf,'renderer','painters');
%% Save data
Tbl = table;
Tbl.X = Calx';
for i=1:dataSize
    name = ['y' num2str(i)];
    Tbl.(name) = CalInt(i,:)';
end

Splited = split(path, filesep);
name = char(Splited(end-1));
pathup = path(1:end-length(name)-1);

save([pathup name '.mat'],'Calx','CalInt')
writetable(Tbl, [pathup name '.csv'])
%% Alarm

for i=1:1
    sound(sin(1:10000));
    pause(2)
end