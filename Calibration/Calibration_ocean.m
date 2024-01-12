clear; close all; clc;
if isempty(gcp('nocreate')); parpool; end

%% Settings

n_dir = 11; %number of folders to be selected before hand
csv_save = false;
alarm = false;
cutting_lims = [0 2500]; %for not cutting leave empty (unit: cm^-1)
plotting = true;

%% Selecting folders

disp('Selected files:')
for k=1:n_dir
    if k==1
        paths{k} = uigetdir(sprintf('Select data folder number %d', k));
    else
        paths{k} = uigetdir(sprintf(pathup, 'Select data folder number %d', k));
    end
    path = paths{k};
    Splited = split(path, filesep);
    name = char(Splited(end));
    pathup = path(1:end-length(name));
    fprintf('%d - %s\n', k, name);
end

%% Calibration

for k = 1:n_dir

    % Importing Data

    path = paths{k};
    List = dir(path);
    if strcmp(List(3).name, '.DS_Store')
        offset = 3;
    else
        offset = 2;
    end
    dataSize = length(List)-offset;
    spec = zeros(dataSize, 1044, 2);
    for i=1:dataSize
        clc;
        disp(strcat("Importing data: ", num2str((i/dataSize)*100), "% - ", List(i+offset).name));
        spec(i,:,:) = dlmread(fullfile(path, List(i+offset).name), "",14,0);
    end
    disp("Reading Data: Done!")

    % Raman Shift Conversion and Calibration

    Calx = zeros(dataSize, 2851);
    CalInt = zeros(dataSize, 2851);

    parfor i=1:dataSize
        RSspec = RamanShiftConverter(spec(i,:,:));
        [Calx(i,:), CalInt(i,:)] = AxisCorr(RSspec);
    end
    Calx = Calx(1,:);
    disp("Raman Shift Conversion and Calibration: Done!")

    % Cutting

    if ~isempty(cutting_lims)
        start = find(Calx == cutting_lims(1));
        stop = find(Calx == cutting_lims(2));

        CalInt = CalInt(:,start:stop);
        Calx = Calx(start:stop);
    end

    % Plotting

    plot(Calx, CalInt);
    xlabel('Raman Shift (cm^{-1})','FontSize',13)
    ylabel('Raman Intensity (a.u.)','FontSize',13)
    box on;
    set(gca,'FontSize',13,'LineWidth',2);
    set(gcf,'renderer','painters');

    % Save data as mat

    Splited = split(path, filesep);
    name = char(Splited(end));
    pathup = path(1:end-length(name));

    save([pathup name '.mat'],'Calx','CalInt')
    fprintf('Data %s has been saved in folder %s\n', name, pathup)

    % Save data as csv

    if csv_save
        Tbl = table;
        Tbl.X = Calx';
        for i=1:dataSize
            cname = ['y' num2str(i)];
            Tbl.(cname) = CalInt(i,:)';
        end
        writetable(Tbl, [pathup name '.csv'])
    end

end

disp('Done!')

%% Alarm

if alarm
    for i=1:3
        sound(sin(1:10000));
        pause(2)
    end
end