clear all;close all;clc;
%% Importing data

[FileName, PathName] = uigetfile('*.mat*', 'Select calibrated data');
FileName_f = fullfile(PathName,FileName);
load(FileName_f)
%% Base selection

BasePoints = [670 780 901 1024 1148 1457 1619 1657 1672 1723 1739 1798 1800];
data = [ht50thp1; ht50thp5; ht50thp10; ht50thp20; ht50thp25; ht50thp40; ht50thp50];
indx_s = find(Calx==BasePoints(1)); indx_f = find(Calx==BasePoints(end));
data_p = data(:, indx_s:indx_f); Calx_p = Calx(:, indx_s:indx_f);

[BCInt, y] = base_correct(BasePoints, Calx_p, data_p, 'linear');

figure, hold on
plot(Calx_p, data_p, Calx_p, y, 'LineWidth', 1.5)
minv = round(min(min(data_p)));
maxv = round(max(max(data_p)));
for i = 1:size(BasePoints,2)
    plot([BasePoints(i) BasePoints(i)],[minv maxv],'k--');
end

figure
plot(Calx_p, BCInt, 'LineWidth', 1.5);