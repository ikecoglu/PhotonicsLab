function [Calx] = saveData(fileName,pathName,Calx,BCInt,NormInt)
path=uigetdir(pathName,'Select where to save analyzed data.');
mkdir(path,'BC');
mkdir(path,'NORM');
PathBC=strcat(path,'/BC/');
PathNorm=strcat(path,'/NORM/');
dataSize=size(BCInt,1);
for i=1:dataSize
    clc;
    disp(strcat("Saving data: ",int2str((i/dataSize)*100),"%"));
    
    M(:,1)=Calx;
    
    M(:,2)=BCInt(i,:);
    dlmwrite(fullfile(PathBC,fileName{i}),M);
    
    M(:,2)=NormInt(i,:);
    dlmwrite(fullfile(PathNorm,fileName{i}),M);
end