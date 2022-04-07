% clear all;close all;clc;
%% Importing data

[name, path] = uigetfile('*.mat*', 'Select calibrated data');
FilePath = fullfile(path,name);
load(FilePath)
%% Base selection
close all
% BasePoints = [407 476 581 663 896 961 1070 1141 1157 1163 1193 1280 1347 1350 1403 1535 1643 1695 1718 1732 1795 1800];
BasePoints = [476 581 663 902 910 962 1023 1026 1030 1033 1075 1147 1150 1163 1177 1201 1270 1273 1419 1471 1477 1529 1547 1592 1683 1712 1726 1738 1744 1772 1798 1862 1894 1925 1945 1988];
% BasePoints = [463 672 902 1029 1165 1275 1594 1726 2043];
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