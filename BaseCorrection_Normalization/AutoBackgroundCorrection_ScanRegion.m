clear; close all; clc;
if isempty(gcp('nocreate')); parpool; end

%% Parameters - User input

Cut = [400, 2000];
Polynomial_order = 5;
UseBackground = false;

PlotFigures = true; % Plot a random sample of the data
nSampling = 20;
SavePNG = true;
SaveFig = true;

Alarm = false;

%% Load background data

if UseBackground
    disp('Select the background data.')
    [name, path] = uigetfile('*.mat');
    fprintf('Background: %s\n', name)
    load(fullfile(path,name))
    Background = mean(CalInt, 1);
    Splited = split(path, filesep);
    name = char(Splited(end));
    pathup = path(1:end-length(name));
else
    Background = zeros(1,Cut(2)-Cut(1)+1);
    Calx = [Cut(1):Cut(2)];
    pathup = '~/';
end

%% Selecting files

[Files, Path] = uigetfile('*_CAL.mat','MultiSelect','on');

%% Cutting background

indx_s = find(Calx==Cut(1));
indx_f = find(Calx==Cut(end));
Background = Background(indx_s:indx_f);

%% Automatic background correction

for k = 1:length(Files)

    clc; fprintf('%d/%d', k, length(Files))

    
    load(fullfile(Path,Files{k}));
    
    name = Files{k}(1:end-8);
    filenamepath = fullfile(Path, name);

    % Cutting data based on base points

    indx_s = find(Calx==Cut(1));
    indx_f = find(Calx==Cut(end));
    CalInt = CalInt(:,:,indx_s:indx_f);
    Calx = Calx(:, indx_s:indx_f);

    % Base correction

    DS1 = size(CalInt, 1);
    DS2 = size(CalInt,2);
    BCInt = nan(DS1, DS2, length(Calx));
    parfor i = 1:DS1
        for j = 1:DS2
            BCInt(i,j,:) = RemoveBackground(reshape(CalInt(i,j,:),1,length(Calx)), Background, Polynomial_order);
        end
    end

    % Normalization

    NormInt = nan(DS1, DS2, length(Calx));

    parfor i = 1:DS1
        for j = 1:DS2
            NormInt(i,j,:) = BCInt(i,j,:)/norm(reshape(BCInt(i,j,:),1,length(Calx)));
        end
    end

    % Plotting sampled data

    if PlotFigures

        Ix = randi(DS1,1,nSampling);
        Iy = randi(DS2,1,nSampling);

        CalInt_samp = [];
        BCInt_samp = [];
        NormInt_samp = [];

        for i = 1:nSampling
            CalInt_samp = [CalInt_samp; CalInt(Ix(i),Iy(i),:)];
            BCInt_samp = [BCInt_samp; BCInt(Ix(i),Iy(i),:)];
            NormInt_samp = [NormInt_samp; NormInt(Ix(i),Iy(i),:)];
        end

        CalInt_samp = reshape(CalInt_samp, nSampling, size(CalInt_samp,3));
        BCInt_samp = reshape(BCInt_samp, nSampling, size(BCInt_samp,3));
        NormInt_samp = reshape(NormInt_samp, nSampling, size(NormInt_samp,3));

        figure
        plot(Calx, CalInt_samp);
        hold on,
        plot(Calx, CalInt_samp-BCInt_samp, 'r')
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        xlim("tight")
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

        figure
        plot(Calx, BCInt_samp);
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        xlim("tight")
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

        figure
        plot(Calx, NormInt_samp);
        xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
        ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
        xlim("tight")
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

    save([filenamepath '_BC.mat'], 'Calx', 'BCInt')
    save([filenamepath '_NORM.mat'], 'Calx', 'NormInt')
end

clc; disp('Done!')

%% Alarm

if Alarm
    for i=1:3
        sound(sin(1:10000));
        pause(2)
    end
end