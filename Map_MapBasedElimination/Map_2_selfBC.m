clear;close all; clc;
%% User input

num_of_step_A = 100;
num_of_step_B = 80;
Point2map = 1128;%the raman shift that is going to be mapped in 3d plot.
n = 2;%averaging window size.
%% Reading data

[fileName, path] = uigetfile('*.mat*','Select data to map.');
FileName = fullfile(path,fileName);
load(FileName)
dataSize = size(CalInt, 1);
%% Base correction

peak=find(Calx==Point2map);
for i=1:dataSize
    clc;
    disp(strcat("Base correction: ", int2str((i/dataSize)*100), "%"));

    [pks,locs] = findpeaks(-CalInt(i,:));
    dips = Calx(locs);
    gtp = find(dips>peak,1);
    gtp = find(Calx==dips(gtp),1);
    ltp = find(dips<peak,1, "last");
    ltp = find(Calx==dips(ltp),1);
    y(i,:)=interp1([Calx(ltp) Calx(gtp)], CalInt(i, [ltp gtp]), Calx, "linear");
    BCInt(i,:)=CalInt(i,:)-y(i,:);

end

%% Mapping

peak=find(Calx==Point2map);
peak=peak-n:peak+n;

Gx=1;Gy=1;
img(Gy,Gx)=mean(BCInt(1,peak));
count = 2;

direct = true;
for k = 1:num_of_step_B + 1
    if direct
        for l = 1:num_of_step_A
            Gy=Gy+1;
            img(Gy,Gx)=mean(BCInt(count,peak));
            count = count + 1;
        end
        direct = false;
    else
        for l = 1:num_of_step_A
            Gy=Gy-1;
            img(Gy,Gx)=mean(BCInt(count,peak));
            count = count + 1;
        end
        direct = true;
    end
    if k ~= num_of_step_B + 1
        Gx=Gx+1;
        img(Gy,Gx)=mean(BCInt(count,peak));
        count = count + 1;
    end
end
clear count direct Gx Gy k l peak
figure
% colormap("gray")
imagesc(img);
% caxis([2700 3300])
% figure,surf(img);
% set(gcf,'Position',[50 50 50+10*(num_of_step_B+1) 50+10*(num_of_step_A+1)])
pbaspect([(num_of_step_A + 1) (num_of_step_B + 1) 1])
set(gcf,'renderer','painters');
% saveas(gcf,[path 'Map_' num2str(Point2map) '.svg']);
% saveas(gcf,[path 'Map_' num2str(Point2map) '.fig']);
% close;
%% Enhanced Contrast Image

% img_rs = uint8(rescale(img, 0, 255));
% img_enp = adapthisteq(img_rs,'clipLimit',0.02,'Distribution','rayleigh');
% img_en = zeros(num_of_step_A+1, num_of_step_B+1);
% i = 1;
% while all(all(img_en ~= img_enp))
%     img_en = img_enp;
%     img_enp = adapthisteq(img_en,'clipLimit',0.02,'Distribution','rayleigh');
%     i = i+1;
% end
% % Display your image
% figure; imshow(img_en, []);
%% Notes from the writer of the code

clc;disp('Always check the scanning direction!')