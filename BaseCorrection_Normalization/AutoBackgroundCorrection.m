clear all; close all; clc;
if isempty(gcp('nocreate')); parpool; end
%% Parameters - User input

n_file = 8; %number of mat files to be selected
SaveCSV = false;
PlotFigures = false;
Alarm = true;
Cut = [400, 1800];
Polynomial_order = 5;

%% Load background data

[name, path] = uigetfile('*.mat','Select background data');
load(fullfile(path,name))
Background = mean(CalInt, 1);
%% Selecting folders

disp('Selected files:')
for k=1:n_file
    if k==1
        [name, path] = uigetfile('*.mat', sprintf('Select data folder number %d', k));
        paths{k} = fullfile(path,name);
    else
        [name, path] = uigetfile([pathup '*.mat'], sprintf('Select data folder number %d', k));
        paths{k} = fullfile(path,name);
    end
    path = paths{k};
    Splited = split(path, filesep);
    name = char(Splited(end));
    pathup = path(1:end-length(name));
    fprintf('%d - %s\n', k, name);
end

%% Cutting background

indx_s = find(Calx==Cut(1));
indx_f = find(Calx==Cut(end));
Background = Background(indx_s:indx_f);
%%

for k = 1:n_file
    
    path = paths{k}
    filenamepath = path(1:end-4);
    load(path)
    %% Cutting data based on base points
    
    CalInt = CalInt(:, indx_s:indx_f);
    Calx = Calx(:, indx_s:indx_f);

    %% Plotting CAL data

    if PlotFigures
        figure
        plot(Calx, CalInt);
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        box on
        set(gca, 'FontSize', 14, 'LineWidth',2)
        title('CAL spectra')
    end

    %% Base correction

    DataSize = size(CalInt, 1);
    BCInt = nan(DataSize, length(Calx));
    parfor i = 1:DataSize
        BCInt(i,:) = RemoveBackground(CalInt(i,:), Background, Polynomial_order);
    end

    if PlotFigures
        figure
        plot(Calx, BCInt);
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        box on
        set(gca, 'FontSize', 14, 'LineWidth',2)
        title('BC spectra')
    end
    %% Normalization

    NormInt = normalization(BCInt);

    if PlotFigures
        figure
        plot(Calx, NormInt);
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        box on
        set(gca, 'FontSize', 14, 'LineWidth',2)
        title('NORM spectra')
    end
    %% Saving

    datasize = size(BCInt, 1);

    save([filenamepath '_BC.mat'], 'Calx', 'BCInt')
    save([filenamepath '_NORM.mat'], 'Calx', 'NormInt')

    if SaveCSV
        Tbl = table;
        Tbl.X = Calx';
        for i=1:datasize
            label= ['y' num2str(i)];
            Tbl.(label) = BCInt(i,:)';
        end
        writetable(Tbl, [filenamepath '_BC.csv'])

        Tbl = table;
        Tbl.X = Calx';
        for i=1:datasize
            label= ['y' num2str(i)];
            Tbl.(label) = NormInt(i,:)';
        end
        writetable(Tbl, [filenamepath '_NORM.csv'])
    end
end
%% Alarm

if Alarm
    for i=1:3
        sound(sin(1:10000));
        pause(2)
    end
end