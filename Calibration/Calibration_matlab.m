clear; close all; clc;
%% Importing data - Ordered

[fileName, path] = uigetfile('*.*','Select raw spectrum data.','MultiSelect', 'on');
dataSize = length(fileName);
name = fileName{1}(1:length(fileName{1})-1);
for i=1:dataSize
    clc;
    disp(strcat("Importing data: ", num2str((i/dataSize)*100), "% - ", [name num2str(i)]));
    spec(i,:,:) = dlmread(fullfile(path, [name num2str(i)]), ",");
end
%% Importing data - Not Ordered
% 
% [fileName, path] = uigetfile('*.*','Select raw spectrum data.','MultiSelect', 'on');
% FileAdress = fullfile(path, fileName);
% dataSize = length(FileAdress);
% for i=1:dataSize
%     clc;
%     disp(strcat("Importing data: ",int2str((i/dataSize)*100),"% - ", fileName{i}));
%     spec(i,:,:) = dlmread(FileAdress{1,i,:},",");
% end
%% Raman Shift Conversion and Calibration

RSspec = RamanShiftConverter(dataSize, spec);
[Calx, CalInt] = AxisCorr(dataSize, RSspec); Calx = Calx(1,:);
%% Cutting

start = find(Calx == 0);
stop = find(Calx == 2500);

CalInt = CalInt(:,start:stop);
Calx = Calx(start:stop);
%% Plotting

plot(Calx, CalInt);
xlabel('Raman Shift (cm^{-1})','FontSize',13)
ylabel('Raman Intensity (a.u.)','FontSize',13)
box on;
set(gca,'FontSize',13,'LineWidth',2);
set(gcf,'renderer','painters');
%% Save data

Tbl = table;
Tbl.X = Calx';
for i=1:dataSize
    name = ['y' num2str(i)];
    Tbl.(name) = CalInt(i,:)';
end

Splited = split(path, filesep);
name = char(Splited(end-1))
pathup = path(1:end-length(name)-1)

save([pathup name '.mat'],'Calx','CalInt')
writetable(Tbl, [pathup name '.csv'])
%% Alarm

for i=1:3
    sound(sin(1:10000));
    pause(2)
end