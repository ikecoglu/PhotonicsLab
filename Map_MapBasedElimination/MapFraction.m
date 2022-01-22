clear all;close all; clc;
%% User input
Length=40; %legth of a side of scanned square. Unit is how many our step so actually legth/stepsize.
Point2map1=1022;%the raman shift that is going to be mapped in 3d plot.
Point2map2=1030;%the raman shift that is going to be mapped in 3d plot.
% Point2map1 / Point2map2 ratio is going to be mapped
%%

[fileName, path] = uigetfile('*.mat*','Select data to map.');
FileName = fullfile(path,fileName);
load(FileName)
dataSize = size(CalInt, 1);
%%
peak1=find(Calx==Point2map1);
peak2=find(Calx==Point2map2);
i=0;b=0;counter=0;Gx=Length;Gy=Length;
img(Gy+1,Gx+1)=CalInt(1,peak1)/CalInt(1,peak2);
while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy-1;
            img(Gy+1,Gx+1)=CalInt(i,peak1)/CalInt(i,peak2);
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gx=Gx-1;
        img(Gy+1,Gx+1)=CalInt(i,peak1)/CalInt(i,peak2);
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy+1;
            img(Gy+1,Gx+1)=CalInt(i,peak1)/CalInt(i,peak2);
        end
        b=b+1;counter=counter+1;
    end
end
clear a b counter Gx Gy i
figure
% colormap("gray")
imagesc(img);
% figure,surf(1:size(img,1),1:size(img,2),img);
% saveas(gcf,'C:\Users\ibrah\Desktop\Map.emf');close;
%% Notes from the writer of the code
clc;disp('Always check whether the scanning direction of image created is same as the scanning you have done.')