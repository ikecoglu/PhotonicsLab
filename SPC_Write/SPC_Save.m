clear all;clc;
[data,fileName,pathName] = DataRead();
data = data(:,:,2);
path=uigetdir(pathName,'Select where to save analyzed data.');
mkdir(path,'SPC');
PathBC=strcat(path,'\SPC\');
for i = 1:size(data,1)
    GSSpcWrite (strcat(PathBC,'THP_',num2str(i),'.spc'), data(i,:), 670:1800);
end