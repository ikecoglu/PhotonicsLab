clc
clear all
%FWHM degeri
% F = input('FWHM degerini girin: ');
F = 5;
%% import table
[file, path] = uigetfile('*.xlsx');
filename = fullfile(path,file);
input = xlsread(filename);
%% Extract probs and centers
for i = 2:size(input,1)
    for j = 2:2:size(input,2)-1
        probT(i-1,j/2) =  input(i,j);
        center2(i-1) = input(i,1); center1(j/2) =  input(1,j);
    end
    for j = 3:2:size(input,2)
        probH(i-1,(j-1)/2) = input(i,j);
    end
end
%THP kons / HT konsantrasyonu. Bizde 3/2 gibi. Oynayabiliriz bunla
T_H_conc = 0;
probT = T_H_conc.*probT;
%% calculate gauss profiles and sum
% Her prob deðeri için birer gauss hesaplayýp topluyoruz. Aðýrlýk merkezini
% bulup histogramýný alýyoruz.
count = 0;
for i= 1:size(probH,1)
    for j = 1:size(probH,2)
        count = count +1;
        if center1(j)<center2(i)
            x = center1(j)-10: (center2(i)-center1(j))/1999: center2(i)+10;
            g1 = gaussGen(x, F, center1(j));
            g2 = gaussGen(x, F, center2(i));
            g = probH(i,j)*g1 + probT(i,j)*g2;
            [fitresult, ~] = gaussFit(x,  g);
            newCenter(count) = fitresult.b1;
            clear g
        elseif center1(j)>center2(i)
            x = center2(i)-10: (center1(j)-center2(i))/1999: center1(j)+10;
            g1 = gaussGen(x, F, center1(j));
            g2 = gaussGen(x, F, center2(i));
            g = probH(i,j)*g1 + probT(i,j)*g2;
            [fitresult, ~] = gaussFit(x,  g);
            newCenter(count) = fitresult.b1;
            clear g
        else
            newCenter(count) = center1(j);
        end
    end
end

%% plot hist
figure, hist(newCenter)
xlim([1020 1035])
% figure,plot(x,g1,'r', x,g2,'b', x, g,'k')
% s = sprintf('center = %s', num2str(newCenter));
% title(s)