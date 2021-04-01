clear all;close all; clc;
%% User input
Length=30; %legth of a side of scanned square. Unit is how many our step so actually legth/stepsize.
Point2map1=1625;%the raman shift that is going to be mapped in 3d plot.
Point2map2=1286;%the raman shift that is going to be mapped in 3d plot.
% Point2map1 / Point2map2 ratio is going to be mapped
%% Process
[fileName, pathName] = uigetfile('*.*','Select data to map.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Reading data: ",int2str((i/dataSize)*100),"%"));
    data(i,:,:)=dlmread(FileName{1,i,:},",");
end
%%
peak1=find(data(1,:,1)==Point2map1);
peak2=find(data(1,:,1)==Point2map2);
i=0;b=0;counter=0;Gx=Length;Gy=Length;
img(Gy+1,Gx+1)=data(1,peak1,2)/data(1,peak2,2);
while i<dataSize
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy-1;
            img(Gy+1,Gx+1)=data(i,peak1,2)/data(i,peak2,2);
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gx=Gx-1;
        img(Gy+1,Gx+1)=data(i,peak1,2)/data(i,peak2,2);
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy+1;
            img(Gy+1,Gx+1)=data(i,peak1,2)/data(i,peak2,2);
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