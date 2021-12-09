clear all;close all; clc;
%% User input

Length = 40; %legth of a side of scanned square. Unit is how many our step so actually legth/stepsize.
Point2map =1602;%the raman shift that is going to be mapped in 3d plot.
n = 2;%averaging window size.
%% Reading data

[fileName, path] = uigetfile('*.mat*','Select data to map.');
FileName = fullfile(path,fileName);
load(FileName)
dataSize = size(CalInt, 1);
%% Mapping

peak=find(Calx == Point2map);
peak=peak-n:peak+n;
i=0;b=0;counter=0;Gx=Length;Gy=Length;
img(Gy+1,Gx+1)=mean(CalInt(1,peak));
while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy-1;
            img(Gy+1,Gx+1)=mean(CalInt(i,peak));
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gx=Gx-1;
        img(Gy+1,Gx+1)=mean(CalInt(i,peak));
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy+1;
            img(Gy+1,Gx+1)=mean(CalInt(i,peak));
        end
        b=b+1;counter=counter+1;
    end
end
clear a b counter Gx Gy i peak
figure
% colormap("gray")
imagesc(img);
% caxis([2700 3300])
% figure,surf(1:size(img,1),1:size(img,2),img);
set(gcf,'renderer','painters');
% saveas(gcf,[path 'Map.svg']);
% saveas(gcf,[path 'Map.fig']);
% close;
%% Notes from the writer of the code

clc;disp('Always check the scanning direction!')