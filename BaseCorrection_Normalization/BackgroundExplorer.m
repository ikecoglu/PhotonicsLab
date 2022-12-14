clear; close all; clc
%% Load background data

[name, path] = uigetfile('*.mat','Select background data');
load(fullfile(path,name))
Background = mean(CalInt, 1);

%%
[name, path] = uigetfile('*.mat','Select data');
load(fullfile(path,name));

%% Deciding on parameters

Start = 400;
Stop = 1800;

indx_str = find(Calx==Start);
indx_stp = find(Calx==Stop);
Spectrum_p = mean(CalInt(:,indx_str:indx_stp),1);
BGround_p = Background(indx_str:indx_stp);
Calx_p = Calx(indx_str:indx_stp);

for Polynomial_order = 4:6
    RS(Polynomial_order, :) = RemoveBackground(Spectrum_p, BGround_p, Polynomial_order);
end

close all
subplot(2,1,1), hold on
plot(Calx_p, Spectrum_p, 'LineWidth', 2, 'DisplayName', 'Spectrum')
plot(Calx_p, Spectrum_p-RS(4,:), 'LineWidth', 2, 'DisplayName', '4th order')
plot(Calx_p, Spectrum_p-RS(5,:), 'LineWidth', 2, 'DisplayName', '5th order')
plot(Calx_p, Spectrum_p-RS(6,:), 'LineWidth', 2, 'DisplayName', '6th order')
legend

subplot(2,1,2), hold on
plot(Calx_p, RS(4,:), 'LineWidth', 2, 'DisplayName', '4th order')
plot(Calx_p, RS(5,:), 'LineWidth', 2, 'DisplayName', '5th order')
plot(Calx_p, RS(6,:), 'LineWidth', 2, 'DisplayName', '6th order')
legend