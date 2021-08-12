clear all;close all; clc;
%% User input

Length = 60; %legth of a side of scanned square. Unit is how many of our_step so actually legth/stepsize.
Normalize_log = false;
%% Reading data new

[fileName, path] = uigetfile('*.mat*','Select data to map.');
FileAdress = fullfile(path,fileName);
load(FileAdress)
Data_Int = CalInt; DataSize = size(Data_Int, 1);

[fileName, path] = uigetfile('*.mat*','Select correlated data.');
FileAdress = fullfile(path,fileName);
load(FileAdress)
Corr_Int = mean(CalInt, 1);

clear CalInt FileAdress fileName path

if Normalize_log
    Corr_Int = Corr_Int./norm(Corr_Int);
    for i = 1:DataSize
        Data_Int(i,:)=Data_Int(i,:)./norm(Data_Int(i,:));
    end
end

for i = 1:DataSize
    A = corrcoef(Corr_Int, Data_Int(i,:));
    Corr_C(i)=A(1,2);
end
clear A
%% Mapping

i=0;b=0; counter=0; Gx=Length; Gy=Length;
img(Gy+1, Gx+1) = Corr_C(1);
while i < DataSize
    a = mod(b,4);
    if(a==0)
        for i = counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy = Gy-1;
            img(Gy+1, Gx+1) = Corr_C(i);
        end
        b = b+1; counter=counter+1;
    end
    if(a==1||a==3)
        i = counter*(Length+1)+1;
        Gx = Gx-1;
        img(Gy+1, Gx+1) = Corr_C(i);
        b = b+1;
    end
    if(a==2)
        for i = counter*(Length+1)+2:(counter+1)*(Length+1)
            Gy = Gy+1;
            img(Gy+1, Gx+1) = Corr_C(i);
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