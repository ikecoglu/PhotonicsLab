clear all; close all; clc;
%% Parameters - User input

mode = 'linear'; % string; Line fitting options: linear, spline
SaveCSV = false;
PlotFigures = false;
Alarm = true;
BasePoints = [476 581 663 902 910 962 1023 1026 1030 1033 1075 1147 1150 1163 1177 1201 1270 1273 1419 1471 1477 1529 1547 1592 1683 1712 1726 1738 1744 1772 1798 1862 1894 1925 1945 1988];
%% Importing data

[FileName, Path] = uigetfile('*.mat*', 'Select calibrated data');
FileName_f = fullfile(Path,FileName);
load(FileName_f)
%% Cutting data based on base points

indx_s = find(Calx==BasePoints(1));
indx_f = find(Calx==BasePoints(end));
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

[BCInt, y] = base_correct(BasePoints, Calx, CalInt, mode);

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
name = FileName(1:end-4);

save([Path name '_BC.mat'], 'Calx', 'BCInt')
save([Path name '_NORM.mat'], 'Calx', 'NormInt')

if SaveCSV
    Tbl = table;
    Tbl.X = Calx';
    for i=1:datasize
        label= ['y' num2str(i)];
        Tbl.(label) = BCInt(i,:)';
    end
    writetable(Tbl, [Path name '_BC.csv'])

    Tbl = table;
    Tbl.X = Calx';
    for i=1:datasize
        label= ['y' num2str(i)];
        Tbl.(label) = NormInt(i,:)';
    end
    writetable(Tbl, [Path name '_NORM.csv'])
end
%% Alarm

if Alarm
    for i=1:3
        sound(sin(1:10000));
        pause(2)
    end
end