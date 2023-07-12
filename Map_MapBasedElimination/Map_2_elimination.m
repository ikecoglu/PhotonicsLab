clear;close all; clc;
%% User input

num_of_step_A = 200;
num_of_step_B = 20;
Point2map = 1324;%the raman shift that is going to be mapped in 3d plot.
n = 2;%averaging window size.
%% Reading data

[fileName, path] = uigetfile('*.mat*','Select data to map.');
FileName = fullfile(path,fileName);
load(FileName)
if exist('CalInt')
    data = CalInt;
elseif exist('BCInt')
    data = BCInt;
elseif exist('NormInt')
    data = NormInt;
end
dataSize = size(data, 1);
%% Mapping

peak=find(Calx==Point2map);
peak=peak-n:peak+n;

% elimination
data_p = mean(data(:,peak),2);
rng(1)
[labels] = kmeans(data_p,3);
[~, k] = max([mean(data_p(labels~=1)), mean(data_p(labels~=2)), mean(data_p(labels~=3))]);
data_elim = data_p;
data_elim(labels==k) = NaN;

%% Map normal

Gx=1;Gy=1;
img(Gy,Gx)=data_p(1);
count = 2;

direct = true;
for k = 1:num_of_step_B + 1
    if direct
        for l = 1:num_of_step_A
            Gy=Gy+1;
            img(Gy,Gx)=data_p(count);
            count = count + 1;
        end
        direct = false;
    else
        for l = 1:num_of_step_A
            Gy=Gy-1;
            img(Gy,Gx)=data_p(count);
            count = count + 1;
        end
        direct = true;
    end
    if k ~= num_of_step_B + 1
        Gx=Gx+1;
        img(Gy,Gx)=data_p(count);
        count = count + 1;
    end
end
clear count direct Gx Gy k l peak

subplot(1,2,1)
nA = num_of_step_A + 1;
nB = num_of_step_B + 1;

img_v = reshape(img, nA*nB, 1);
img_v(isoutlier(img_v)) = median(img_v);
% img_v(isoutlier(img_v)) = NaN;
img_e = reshape(img_v, nA, nB);
imagesc(img_e)
pbaspect([nB nA 1])
set(gcf,'renderer','painters');
%% Map eliminated

Gx=1;Gy=1;
img(Gy,Gx)=data_elim(1);
count = 2;

direct = true;
for k = 1:num_of_step_B + 1
    if direct
        for l = 1:num_of_step_A
            Gy=Gy+1;
            img(Gy,Gx)=data_elim(count);
            count = count + 1;
        end
        direct = false;
    else
        for l = 1:num_of_step_A
            Gy=Gy-1;
            img(Gy,Gx)=data_elim(count);
            count = count + 1;
        end
        direct = true;
    end
    if k ~= num_of_step_B + 1
        Gx=Gx+1;
        img(Gy,Gx)=data_elim(count);
        count = count + 1;
    end
end
clear count direct Gx Gy k l peak
subplot(1,2,2)
nA = num_of_step_A + 1;
nB = num_of_step_B + 1;

img_v = reshape(img, nA*nB, 1);
img_v(isoutlier(img_v)) = median(img_v);
% img_v(isoutlier(img_v)) = NaN;
img_e = reshape(img_v, nA, nB);
imagesc(img_e)
pbaspect([nB nA 1])
% caxis([2700 3300])
% figure,surf(img);
set(gcf,'renderer','painters');
% print(gcf,[path 'Map_' num2str(Point2map) '.png'],'-dpng','-r600');
% % saveas(gcf,[path 'Map_' num2str(Point2map) '.svg']);
% % saveas(gcf,[path 'Map_' num2str(Point2map) '.fig']);
% close;
%% Notes from the writer of the code

clc;disp('Always check the scanning direction!')