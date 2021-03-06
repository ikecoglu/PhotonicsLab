clear all; close all; clc;
%% Settings

csv_save = false;
cutting_lims = [0 2500]; %for not cutting leave empty (unit: cm^-1)
%% Importing data - Not ordered

path = uigetdir('Select data folder.');
List = dir(path);
dataSize = length(List)-2;
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ", num2str((i/dataSize)*100), "% - ", List(i+2).name));
    spec(i,:,:) = dlmread(fullfile(path, List(i+2).name), "",14,0);
end
%% Raman Shift Conversion and Calibration

RSspec = RamanShiftConverter(dataSize,spec);
[Calx,CalInt] = AxisCorr(dataSize,RSspec);Calx=Calx(1,:);
%% Cutting

if ~isempty(cutting_lims)
    start = find(Calx == cutting_lims(1));
    stop = find(Calx == cutting_lims(2));

    CalInt = CalInt(:,start:stop);
    Calx = Calx(start:stop);
end
%% Plotting

plot(Calx, CalInt);
xlabel('Raman Shift (cm^{-1})','FontSize',13)
ylabel('Raman Intensity (a.u.)','FontSize',13)
box on;
set(gca,'FontSize',13,'LineWidth',2);
set(gcf,'renderer','painters');
%% Save data as mat

Splited = split(path, filesep);
name = char(Splited(end));
pathup = path(1:end-length(name));

save([pathup name '.mat'],'Calx','CalInt')
fprintf('Data %s has been saved in folder %s\n', name, pathup)
%% Save data as csv

if csv_save
    Tbl = table;
    Tbl.X = Calx';
    for i=1:dataSize
        cname = ['y' num2str(i)];
        Tbl.(cname) = CalInt(i,:)';
    end
    writetable(Tbl, [pathup name '.csv'])
end
%% Alarm

for i=1:3
    sound(sin(1:10000));
    pause(2)
end