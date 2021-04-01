clear all;close all; clc;
%% Reading data
[fileName, pathName] = uigetfile('*.*','Select data to map.','MultiSelect', 'on');
FileName=fullfile(pathName,fileName);
dataSize=length(FileName);
for i=1:dataSize
    clc;
    disp(strcat("Reading data: ",int2str((i/dataSize)*100),"%"));
    data(i,:,:)=dlmread(FileName{1,i,:},",");
end
Calx = data(1,:,1);
%% Process
Point= 1385;
n=1;
a=355;
clc;
Point;
peak=find(Calx(1,:,1)==Point);
peak=peak-n:peak+n;

HEC =mean(hec(1:a,peak),2);
HELA =mean(hela(1:a,peak),2);
HT =mean(ht(1:a,peak),2);
THP =mean(thp(1:a,peak),2);
THP10 =mean(thp10(1:a,peak),2);
THP25 =mean(thp25(1:a,peak),2);
THP50 =mean(thp50(1:a,peak),2);
THP100 =mean(thp100(1:a,peak),2);
DATA = [HEC;HELA;HT;THP;THP10;THP25;THP50;THP100];
L1 = repmat({'HEC1A'},a,1);
L2 = repmat({'HeLa'},a,1);
L3 = repmat({'HT1080'},a,1);
L4 = repmat({'THP'},a,1);
L5 = repmat({'THP10'},a,1);
L6 = repmat({'THP25'},a,1);
L7 = repmat({'THP50'},a,1);
L8 = repmat({'THP100'},a,1);
L = [L1;L2;L3;L4;L5;L6;L7;L8];

boxplot(DATA,L);
set(gca,'FontSize',12);
title(strcat('Peak: ',num2str(Point)));
xlabel('Cell Lines');
ylabel('Normalized Raman Intensity (a. u)');
set(gcf, 'Position', get(0, 'Screensize'));
if ~exist('~/Workspace/PhotonicsLab/BoxChart/', 'dir')
    mkdir('~/Workspace/PhotonicsLab/BoxChart')
end
saveas(gcf,fullfile('~/Workspace/PhotonicsLab/BoxChart/',strcat('Peak_ ',num2str(Point),'.png')));
pause(1);
close;