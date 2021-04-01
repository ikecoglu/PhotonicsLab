clear all;close all; clc;
%% User input
Length=30; %legth of a side of scanned square. Unit is how many of our_step so actually legth/stepsize.
Normalize=1;
%% Reading data
[fileName, pathName] = uigetfile('*.*','Select data to map.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
datasize=length(FileName);
for i=1:datasize
    clc;
    disp(strcat("Reading data: ",int2str((i/datasize)*100),"%"));
    data(i,:,:)=dlmread(FileName{1,i,:},",");
end
clear datasize fileName FileName pathName
X=data(1,:,1);Int=data(:,:,2);clear data;

[fileName, pathName] = uigetfile('*.*','Select correlated data.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
datasize=length(FileName);
for i=1:datasize
    clc;
    disp(strcat("Reading data: ",int2str((i/datasize)*100),"%"));
    CorrData(i,:,:)=dlmread(FileName{1,i,:},",");
end
clear datasize fileName FileName pathName
CorrData=mean(CorrData(:,:,2),1);

if Normalize==1
    CorrData=CorrData./max(CorrData);
    for i=1:size(data,1)
        data(i,:,2)=data(i,:,2)./max(data(i,:,2));
    end
end
clear Normalize

for i=1:size(Int,1)
    A=corrcoef(CorrData,Int(i,:));
    CorCoef(i)=A(1,2);
end
clear A
%% Process
i=0;b=0;counter=0;Gx=Length;Gy=Length;
img(Gy+1,Gx+1)=CorCoef(1);
while i<size(Int,1)
    a=mod(b,4);
    if(a==0)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy-1;
            img(Gy+1,Gx+1)=CorCoef(i);
        end
        b=b+1;counter=counter+1;
    end
    if(a==1||a==3)
        i=counter*(Length+1)+1;
        Gx=Gx-1;
        img(Gy+1,Gx+1)=CorCoef(i);
        b=b+1;
    end
    if(a==2)
        for i=counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy=Gy+1;
            img(Gy+1,Gx+1)=CorCoef(i);
        end
        b=b+1;counter=counter+1;
    end
end
clear a b counter Gx Gy i
figure
% colormap("gray")
imagesc(img);
% caxis([2700 3300])
%figure,surf(1:size(img,1),1:size(img,2),img);
% saveas(gcf,'C:\Users\ibrah\Desktop\CorrelationMap.emf');close;
%% Notes from the writer of the code
clc;disp('Always check whether the scanning direction of image created is same as the scanning you have done.')