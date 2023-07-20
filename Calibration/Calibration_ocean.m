clear; close all; clc;
if isempty(gcp('nocreate')); parpool; end;
%% Settings

csv_save = false;
cutting_lims = []; %for not cutting leave empty (unit: cm^-1)
%% Importing data - Not ordered

path = uigetdir('Select data folder.');
List = dir(path);
dataSize = length(List);
j = 1;
for i=1:dataSize
    clc;
    if List(i).name(1) ~= '.'
        disp(strcat("Importing data: ", num2str((i/dataSize)*100), "% - ", List(i).name));
        spec(j,:,:) = dlmread(fullfile(path, List(i).name), "",14,0);
        j = j + 1;
    end
end
dataSize = size(spec,1);
%% Raman Shift Conversion and Calibration

Calx = zeros(dataSize, 2851);
CalInt = zeros(dataSize, 2851);

parfor i=1:dataSize
    RSspec = RamanShiftConverter(dataSize, spec(i,:,:));
    [Calx(i,:), CalInt(i,:)] = AxisCorr(RSspec);
end
Calx = Calx(1,:);
disp("Raman Shift Conversion and Calibration: Done!")
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