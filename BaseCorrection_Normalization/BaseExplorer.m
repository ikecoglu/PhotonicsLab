clear all;close all;clc;
%% Importing data

[name, path] = uigetfile('*.mat*', 'Select calibrated data');
FilePath = fullfile(path,name);
load(FilePath)
%% Base selection
close all
BasePoints = [];
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