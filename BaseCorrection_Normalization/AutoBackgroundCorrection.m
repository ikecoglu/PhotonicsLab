clear; close all; clc;
if isempty(gcp('nocreate')); parpool; end

%% Parameters - User input

n_file = 4; %number of mat files to be selected
Cut = [200, 1800];
Polynomial_order = 5;

PlotFigures = true;
SavePNG = true;
SaveFig = false;

SaveCSV = false;

Alarm = false;

%% Load background data

disp('Select the background data.')
[name, path] = uigetfile('*.mat');
fprintf('Background: %s\n', name)
load(fullfile(path,name))
Background = mean(CalInt, 1);
Splited = split(path, filesep);
name = char(Splited(end));
pathup = path(1:end-length(name));

%% Selecting folders

for k=1:n_file
    fprintf('Select file %d\n', k)
    [name, path] = uigetfile(pathup, '*.mat');
    fprintf('File %d: %s\n', k, name)
    paths{k} = fullfile(path,name);
    path = paths{k};
    Splited = split(path, filesep);
    name = char(Splited(end));
    pathup = path(1:end-length(name));
end

%% Cutting background

indx_s = find(Calx==Cut(1));
indx_f = find(Calx==Cut(end));
Background = Background(indx_s:indx_f);

%% Automatic background correction

for k = 1:n_file

    path = paths{k};
    filenamepath = path(1:end-4);
    load(path)

    % Cutting data based on base points

    CalInt = CalInt(:, indx_s:indx_f);
    Calx = Calx(:, indx_s:indx_f);

    % Plotting CAL data

    if PlotFigures
        figure
        plot(Calx, CalInt);
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        box on
        set(gca, 'FontSize', 14, 'LineWidth',2)
        title('CAL spectra')

        if SavePNG
            print(gcf,sprintf('%s_CAL.png', filenamepath),'-dpng','-r1000');
        end
        if SaveFig
            saveas(gcf,sprintf('%s_CAL.fig', filenamepath));
        end
        close;
    end

    % Base correction

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

        if SavePNG
            print(gcf,sprintf('%s_BC.png', filenamepath),'-dpng','-r1000');
        end
        if SaveFig
            saveas(gcf,sprintf('%s_BC.fig', filenamepath));
        end
        close;
    end

    % Normalization

    NormInt = normalization(BCInt);

    if PlotFigures
        figure
        plot(Calx, NormInt);
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        box on
        set(gca, 'FontSize', 14, 'LineWidth',2)
        title('NORM spectra')

        if SavePNG
            print(gcf,sprintf('%s_NORM.png', filenamepath),'-dpng','-r1000');
        end
        if SaveFig
            saveas(gcf,sprintf('%s_NORM.fig', filenamepath));
        end
        close;
    end

    % Saving

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

disp('Done!')

%% Alarm

if Alarm
    for i=1:3
        sound(sin(1:10000));
        pause(2)
    end
end