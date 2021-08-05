function []=map_2(data, Calx, num_of_step_A, num_of_step_B, Point2map, n, titlestr)
peak=find(Calx==Point2map);
peak=peak-n:peak+n;
Gx=1;Gy=1;
img(Gy,Gx)=mean(data(1,peak));
count = 2;

direct = true;
for k = 1:num_of_step_B + 1
    if direct
        for l = 1:num_of_step_A
            Gy=Gy+1;
            img(Gy,Gx)=mean(data(count,peak));
            count = count + 1;
        end
        direct = false;
    else
        for l = 1:num_of_step_A
            Gy=Gy-1;
            img(Gy,Gx)=mean(data(count,peak));
            count = count + 1;
        end
        direct = true;
    end
    if k ~= num_of_step_B + 1
        Gx=Gx+1;
        img(Gy,Gx)=mean(data(count,peak));
        count = count + 1;
    end
end
%



% clear a b counter Gx Gy
figure
% surf(img)
% hold on
colormap(summer)
im1=imagesc(img);
colorbar
title(titlestr)
% im1.AlphaData=0.5;
% caxis([500 11500])
% figure,surf(1:size(img,1),1:size(img,2),img);
% set(gcf,'renderer','painters');
% saveas(gcf,'C:\Users\ibrah\Desktop\Map.emf');close;
end