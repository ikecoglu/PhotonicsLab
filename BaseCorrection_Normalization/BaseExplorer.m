% clear all;close all;clc;
%% Importing data

[name, path] = uigetfile('*.mat*', 'Select calibrated data');
FilePath = fullfile(path,name);
load(FilePath)
%% Base selection
close all
% BasePoints = [407 476 581 663 896 961 1070 1141 1157 1163 1193 1280 1347 1350 1403 1535 1643 1695 1718 1732 1795 1800];
BasePoints = [476 581 896 961 1141 1157 1163 1193 1280 1347 1350 1403 1535 1643 1695 1718 1732 1795 1800];
indx_s = find(Calx==BasePoints(1)); indx_f = find(Calx==BasePoints(end));
data = mean(CalInt(:, indx_s:indx_f),1); Calx_p = Calx(:, indx_s:indx_f);

[BCInt, y] = base_correct(BasePoints, Calx_p, data, 'linear');

figure, hold on
plot(Calx_p, data, Calx_p, y, 'LineWidth', 1.5)
minv = round(min(min(data)));
maxv = round(max(max(data)));
for i = 1:size(BasePoints,2)
    plot([BasePoints(i) BasePoints(i)],[minv maxv],'k--');
end

figure
plot(Calx_p, BCInt, 'LineWidth', 1.5);