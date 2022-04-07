clear; close all; clc;
%% Parameters

num_of_step_A = 80;
num_of_step_B = 240;
NumberofGroups = 4;
Normalize_log = false;
Cutting_log = false;
Start = 400;
Stop = 1800;
Seed = 1; % For reproducibility 
%% Import

[fileName, path] = uigetfile('*.mat*', 'Select data to map.');
FileAdress = fullfile(path, fileName);
load(FileAdress)
if exist('CalInt')
    data = CalInt;
elseif exist('BCInt')
    data = BCInt;
elseif exist('NormInt')
    data = NormInt;
end
DataSize = size(data, 1);

if Normalize_log
    for i = 1:DataSize
        data(i,:)=data(i,:)./norm(data(i,:));
    end
end

if Cutting_log
    Start_indx = find(Calx==Start,1);
    Stop_indx = find(Calx==Stop,1);
    data = data(:, Start_indx:Stop_indx);
    Calx = Calx(Start_indx:Stop_indx);
    clear Start_indx Stop_indx
end
%% PCA

[coeff, score, ~, ~, explained] = pca(data);
%% Kmeans

rng(Seed);
[labels] = kmeans(score(:,1:2), NumberofGroups);
%% Kmeans scatter

MarkSize = 15;
figure, hold on
for i = 1:NumberofGroups
    plot(score(find(labels==i),1), score(find(labels==i), 2), '.', 'MarkerSize', MarkSize, 'DisplayName', sprintf('Group %d', i))
end
legend('Show')
xlabel(sprintf('PC 1 (%.2f%%)', explained(1)),'FontSize',18); ylabel(sprintf('PC 2 (%.2f%%)', explained(2)),'FontSize',18);
box on;
set(gca, 'FontSize', 18, 'LineWidth',2)
set(gcf,'renderer','painters');
saveas(gcf,[path 'KmeansPCA_k' num2str(NumberofGroups) '.svg']);
saveas(gcf,[path 'KmeansPCA_k' num2str(NumberofGroups) '.fig']);
print(gcf, [path 'KmeansPCA_k' num2str(NumberofGroups) '.png'],'-dpng','-r600');
close;
%% Mean spectrums of groups

LinWid = 2;
figure, hold on
for i = 1:NumberofGroups
    plot(Calx, mean(data(find(labels==i), :), 1), 'LineWidth', LinWid, 'DisplayName', sprintf('Group %d', i))
end
legend('Show')
xlabel('Raman Shift (cm^{-1})','FontSize',18); ylabel('Raman Intensity (a.u.)','FontSize',18)
box on;
xlim([Calx(1) Calx(end)])
set(gca, 'FontSize', 18, 'LineWidth',2)
set(gcf,'renderer','painters');
saveas(gcf,[path 'KmeansSpectra_k' num2str(NumberofGroups) '.svg']);
saveas(gcf,[path 'KmeansSpectra_k' num2str(NumberofGroups) '.fig']);
print(gcf, [path 'KmeansSpectra_k' num2str(NumberofGroups) '.png'],'-dpng','-r600');
close;
%% Loading plots

LinWid = 2;
figure, hold on
for i = 1:4
    plot(Calx, coeff(:,i), 'LineWidth', LinWid, 'DisplayName', sprintf('PC = %d', i));
end
legend('Show')
xlabel('Raman Shift (cm^{-1})','FontSize',18); ylabel('Loading (a.u.)','FontSize',18)
box on;
xlim([Calx(1) Calx(end)])
set(gca, 'FontSize', 18, 'LineWidth',2)
set(gcf,'renderer','painters');
saveas(gcf,[path 'KmeansLoadings_k' num2str(NumberofGroups) '.svg']);
saveas(gcf,[path 'KmeansLoadings_k' num2str(NumberofGroups) '.fig']);
print(gcf, [path 'KmeansLoadings_k' num2str(NumberofGroups) '.png'],'-dpng','-r600');
close;
%% Mapping

Gx=1;Gy=1;
img(Gy,Gx)=labels(1);
count = 2;

direct = true;
for k = 1:num_of_step_B + 1
    if direct
        for l = 1:num_of_step_A
            Gy=Gy+1;
            img(Gy,Gx)=labels(count);
            count = count + 1;
        end
        direct = false;
    else
        for l = 1:num_of_step_A
            Gy=Gy-1;
            img(Gy,Gx)=labels(count);
            count = count + 1;
        end
        direct = true;
    end
    if k ~= num_of_step_B + 1
        Gx=Gx+1;
        img(Gy,Gx)=labels(count);
        count = count + 1;
    end
end
clear count direct Gx Gy i k l LinWid MarkSize
figure
Color_list = [0 0.4470 0.7410; ...
 0.8500 0.3250 0.0980; ...
 0.9290 0.6940 0.1250; ...
 0.4940 0.1840 0.5560; ...
 0.4660 0.6740 0.1880; ...
 0.3010 0.7450 0.9330];

colormap(Color_list(1:NumberofGroups,:))
imagesc(img);
% caxis([2700 3300])
% figure,surf(1:size(img,1),1:size(img,2),img);
% set(gcf,'Position',[50 50 50+10*(num_of_step_B+1) 50+10*(num_of_step_A+1)])
pbaspect([(num_of_step_B + 1) (num_of_step_A + 1) 1])
set(gcf,'renderer','painters');
saveas(gcf,[path 'KmeansMap_k' num2str(NumberofGroups) '.svg']);
saveas(gcf,[path 'KmeansMap_k' num2str(NumberofGroups) '.fig']);
close;
%% Notes from the writer of the code

clc;disp('Always check the scanning direction!')