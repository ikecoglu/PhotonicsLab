clear all;close all;clc;
%% User input
Length=70; %legth of a side of scanned square. Unit is how many our step so actually legth/stepsize.
Point2map=1506;%the raman shift that is going to be mapped in 3d plot. Use 1269 to eliminate outliers.
n=0;%averaging window size.
dataSize=(Length+1)^2;
%% Reading data
%Data can be imported with a mat file. In this case name the data as "data"
%and skip this section.
[fileName, pathName] = uigetfile('*.*','Select data to map.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    data(i,:,:)=dlmread(FileName{1,i,:},",");
end
Calx=data(1,:,1);
figure,plot(Calx,data(:,:,2));
%% Finding Outliers
% In order to try different tresholds, just change "trs" and rerun this
% section.
trs=125;
%to create the list and then use outlierRemover function to remove outliers
%from all forms of that data (CAL,BC,NORM)
list = outlierFinderFunc(data,dataSize,Length,Point2map,trs);
clc
disp(strcat('Size of eliminated data: ',num2str(dataSize-length(list))))
%% Removal
[ed_data] = outlierRemover(data,list);
%% save data
path=uigetdir('Select where to save calibrated data.');
mkdir(path,'ED_CAL');
PathCAL=strcat(path,'\ED_CAL\');
for i=1:size(ed_data,1)
    clc;disp(strcat("Saving data: ",int2str((i/size(ed_data,1))*100),"%"));
    M(:,1)=Calx;
    M(:,2)=ed_data(i,:);
    dlmwrite(fullfile(PathCAL,fileName{i}),M);
end