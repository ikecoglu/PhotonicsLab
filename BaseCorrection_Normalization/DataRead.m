function [cal,fileName,pathName] = DataRead()
%% importing data 
[fileName, pathName] = uigetfile('*.*','Select calibrated data.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ",int2str((i/dataSize)*100),"%"));
    cal(i,:,:)=dlmread(FileName{1,i,:},",");
end
up = strfind(pathName,filesep);
pathName = pathName(1:up(end-1)-1);