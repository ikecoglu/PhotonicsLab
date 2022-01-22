clear all; close all; clc;
%% Parameters

mode = 'linear'; % string; Line fitting options: linear, spline
%BasePoints=[670, 685, 768, 909, 948, 970, 1088, 1205, 1401, 1576, 1628, 1720, 1767, 1800]; %pure cell line base
%BasePoints = [670,690,764,950,1094,1207,1401,1480,1576,1628,1565,1725,1767,1800];%uur
%BasePoints = [670 780 901 1024 1148 1457 1619 1657 1672 1723 1739 1798 1800]; %Mixed cell lines
BasePoints = [407 476 581 663 896 961 1070 1141 1157 1163 1193 1280 1347 1350 1403 1535 1643 1695 1718 1732 1795 1800];
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

figure
plot(Calx, CalInt);
xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
box on
set(gca, 'FontSize', 14, 'LineWidth',2)
title('CAL spectra')
%% Base correction

[BCInt, y] = base_correct(BasePoints, Calx, CalInt, mode);

figure
plot(Calx, BCInt);
xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
box on
set(gca, 'FontSize', 14, 'LineWidth',2)
title('BC spectra')
%% Normalization

NormInt = normalization(BCInt);

figure
plot(Calx, NormInt);
xlabel('Raman Shift (cm^{-1})', 'FontSize', 18)
ylabel('Raman Intensity (a.u.)', 'FontSize', 18)
box on
set(gca, 'FontSize', 14, 'LineWidth',2)
title('NORM spectra')
%% Saving

datasize = size(BCInt, 1);

Tbl = table;
Tbl.X = Calx';
for i=1:datasize
    label= ['y' num2str(i)];
    Tbl.(label) = BCInt(i,:)';
end
name = FileName(1:end-4);
save([Path name '_BC.mat'], 'Calx', 'BCInt')
writetable(Tbl, [Path name '_BC.csv'])

Tbl = table;
Tbl.X = Calx';
for i=1:datasize
    label= ['y' num2str(i)];
    Tbl.(label) = NormInt(i,:)';
end
name = FileName(1:end-4);
save([Path name '_NORM.mat'], 'Calx', 'NormInt')
writetable(Tbl, [Path name '_NORM.csv'])