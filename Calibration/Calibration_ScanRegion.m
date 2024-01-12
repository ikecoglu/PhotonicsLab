clear; close all; clc;
if isempty(gcp('nocreate')); parpool; end

%% Settings

cutting_lims = []; %for not cutting leave empty (unit: cm^-1)
alarm = true;

%% Selecting folders

disp('Selected files:')
[Files, Path] = uigetfile('*.mat', sprintf('Select data files'), 'MultiSelect', 'on');

%% Calibration

for k = 1:length(Files)

    % Importing data

    load(fullfile(Path,Files{k}));

    % Raman Shift Conversion and Calibration

    DS1 = size(RawData,1);
    DS2 = size(RawData,2);
    CalInt = zeros(DS1, DS2, 2851);
    Calx = -87:2763;

    parfor i=1:DS1
        for j=1:DS2

            spec = reshape([wl'; reshape(RawData(i,j,:), 1, 1044)], 1, 1044, 2);
            RSspec = RamanShiftConverter(spec);
            [~, CalInt(i,j,:)] = AxisCorr(RSspec);

        end
    end
    disp("Done!")

    % Cutting

    if ~isempty(cutting_lims)
        start = find(Calx == cutting_lims(1));
        stop = find(Calx == cutting_lims(2));

        CalInt = CalInt(:,:,start:stop);
        Calx = Calx(start:stop);
    end

    % Save data as mat

    name = Files{k}(1:end-4);

    save(fullfile(Path,[name '_CAL.mat']),'Calx','CalInt')
    fprintf('Data %s has been saved\n', name)
end

%% Alarm

if alarm
    for i=1:3
        sound(sin(1:10000));
        pause(2)
    end
end