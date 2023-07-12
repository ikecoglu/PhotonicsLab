clear all;close all; clc;
%% User input

Length = 50; %legth of a side of scanned square. Unit is how many our step so actually legth/stepsize.
Point2map = 1300;%the raman shift that is going to be mapped in 3d plot.
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

peak=find(Calx == Point2map);
peak=peak-n:peak+n;

% elimination
data_p = mean(data(:,peak),2);
rng(1)
[labels] = kmeans(data_p,3);
[~, k] = max([mean(data_p(labels~=1)), mean(data_p(labels~=2)), mean(data_p(labels~=3))]);
data_elim = data_p;
data_elim(labels==k) = NaN;
%% map normal

i=0;b=0;counter=0;Gx=Length;Gy=Length;
img(Gy+1,Gx+1)=data_p(1);
while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy-1;
            img(Gy+1,Gx+1)=data_p(i);
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gx=Gx-1;
        img(Gy+1,Gx+1)=data_p(i);
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy+1;
            img(Gy+1,Gx+1)=data_p(i);
        end
        b=b+1;counter=counter+1;
    end
end
clear a b counter Gx Gy i
subplot(1,2,1)
title("Before elimination")
imagesc(img);
set(gcf,'renderer','painters');
%% map eliminated

i=0;b=0;counter=0;Gx=Length;Gy=Length;
img(Gy+1,Gx+1)=data_elim(1);
while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy-1;
            img(Gy+1,Gx+1)=data_elim(i);
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gx=Gx-1;
        img(Gy+1,Gx+1)=data_elim(i);
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy+1;
            img(Gy+1,Gx+1)=data_elim(i);
        end
        b=b+1;counter=counter+1;
    end
end
clear a b counter Gx Gy i
subplot(1,2,2)
title("After elimination")
imagesc(img);
set(gcf,'renderer','painters');
% saveas(gcf,[path 'Map.svg']);
% saveas(gcf,[path 'Map.fig']);
% close;
%% Notes from the writer of the code

clc;disp('Always check the scanning direction!')