clear; close all; clc;
%% Parameters

Length = 60;
NumberofGroups = 4;
Normalize_log = false;
Seed = 1; % For reproducibility 
%% Import

[fileName, path] = uigetfile('*.mat*', 'Select data to map.');
FileAdress = fullfile(path, fileName);
load(FileAdress)
DataSize = size(CalInt, 1);

if Normalize_log
    for i = 1:DataSize
        CalInt(i,:)=CalInt(i,:)./norm(CalInt(i,:));
    end
end
%% PCA

[coeff, score, ~, ~, explained] = pca(CalInt);
%% Kmeans

rng(Seed);
[labels] = kmeans(score(:,1:2), NumberofGroups);
%% Kmeans scatter

MarkSize = 15;
figure, hold on
for i = 1:NumberofGroups
    plot(score(find(labels==i),1), score(find(labels==i), 2), '.', 'MarkerSize', MarkSize)
end
xlabel('PC 1'); ylabel('PC 2')
%% Mean spectrums of groups

LinWid = 2;
figure, hold on
for i = 1:NumberofGroups
    plot(Calx, mean(CalInt(find(labels==i), :), 1), 'LineWidth', LinWid)
end
xlabel('Raman Shift (cm^{-1})'); ylabel('Raman Intensity (a.u.)')
%% Mapping

i=0;b=0; counter=0; Gx=Length; Gy=Length;
img(Gy+1, Gx+1) = labels(1);
while i < DataSize
    a = mod(b,4);
    if(a==0)
        for i = counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy = Gy-1;
            img(Gy+1, Gx+1) = labels(i);
        end
        b = b+1; counter=counter+1;
    end
    if(a==1||a==3)
        i = counter*(Length+1)+1;
        Gx = Gx-1;
        img(Gy+1, Gx+1) = labels(i);
        b = b+1;
    end
    if(a==2)
        for i = counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy = Gy+1;
            img(Gy+1, Gx+1) = labels(i);
        end
        b = b+1; counter = counter+1;
    end
end
clear a b counter Gx Gy i
figure
% colormap("gray")
imagesc(img);
% caxis([2700 3300])
% figure,surf(1:size(img,1),1:size(img,2),img);
% set(gcf,'renderer','painters');
%% Notes from the writer of the code

clc;disp('Always check the scanning direction!')