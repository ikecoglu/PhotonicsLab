clear all;close all;clc;load('C:\Users\ibrah\Desktop\Photonics_Workspace\CellLineData.mat')
%% Settings
xstart=1020; xstep=0.1; xstop=1035; ylimit=0.15;
gaussfit=1; % 1 = On ; 0 = Off
BinWidth = 0.1;
% User input ends here --------------------------------------------------
edges = [xstart-(BinWidth/2):BinWidth:xstop+(BinWidth/2)];
middles = [xstart:BinWidth:xstop];
Str = find(Calx==xstart);Stp = find(Calx==xstop);Xn=Calx(Str:Stp);X=xstart:xstep:xstop;
%% HT1080
figure
hold on
for i =1:size(ht,1)
    Y(i,:) = interp1(Xn,ht(i,Str:Stp),xstart:xstep:xstop,'spline');
    y(i)=max(Y(i,:));
    x(i)=X(find(Y(i,:)==y(i),1));
end
clear HT
h1=histogram(x,edges,'Normalization','probability');
HT(1,:)=middles;
HT(2,:)=h1.Values;
clear i x y Y h1
ylim([0 ylimit])
xlim([xstart xstop])
title('HT1080')
if gaussfit == 1
    PeakStart=find(HT(1,:)==1020.4,1);
    PeakEnd=find(HT(1,:)==1021.7,1);
    HThandle.peak1=fit(HT(1,PeakStart:PeakEnd)',HT(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(HT(1,:)==1023.2,1);
    PeakEnd=find(HT(1,:)==1024.6,1);
    HThandle.peak2=fit(HT(1,PeakStart:PeakEnd)',HT(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(HT(1,:)==1026.2,1);
    PeakEnd=find(HT(1,:)==1028,1);
    HThandle.peak3=fit(HT(1,PeakStart:PeakEnd)',HT(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(HT(1,:)==1029.2,1);
    PeakEnd=find(HT(1,:)==1030.7,1);
    HThandle.peak4=fit(HT(1,PeakStart:PeakEnd)',HT(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(HT(1,:)==1032.3,1);
    PeakEnd=find(HT(1,:)==1033.4,1);
    HThandle.peak5=fit(HT(1,PeakStart:PeakEnd)',HT(2,PeakStart:PeakEnd)','gauss1');
    HThandle.HThistdata=HT;
    syms x
    Func = (HThandle.peak1.a1*exp(-((x-HThandle.peak1.b1)/HThandle.peak1.c1)^2))+(HThandle.peak2.a1*exp(-((x-HThandle.peak2.b1)/HThandle.peak2.c1)^2))+(HThandle.peak3.a1*exp(-((x-HThandle.peak3.b1)/HThandle.peak3.c1)^2))+(HThandle.peak4.a1*exp(-((x-HThandle.peak4.b1)/HThandle.peak4.c1)^2))+(HThandle.peak5.a1*exp(-((x-HThandle.peak5.b1)/HThandle.peak5.c1)^2));
    HThandle.peaks(1,:) = xstart:0.01:xstop;
    HThandle.peaks(2,:) = double(subs(Func,x,HThandle.peaks(1,:)));
    plot(HThandle.peaks(1,:),HThandle.peaks(2,:),'LineWidth',3)
    clear x HT Func
end
set(gcf, 'Position', get(0, 'Screensize'));
%%
figure
hold on
for i =1:size(thp,1)
    Y(i,:) = interp1(Xn,thp(i,Str:Stp),xstart:xstep:xstop,'spline');
    y(i)=max(Y(i,:));
    x(i)=X(find(Y(i,:)==y(i),1));
end
clear THP
h2=histogram(x,edges,'Normalization','probability');
THP(1,:)=middles;
THP(2,:)=h2.Values;
clear i x y Y h2
ylim([0 ylimit])
xlim([xstart xstop])
title('THP')
if gaussfit == 1
    PeakStart=find(THP(1,:)==1020.3,1);
    PeakEnd=find(THP(1,:)==1021.1,1);
    THPhandle.peak1=fit(THP(1,PeakStart:PeakEnd)',THP(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(THP(1,:)==1022.7,1);
    PeakEnd=find(THP(1,:)==1024.5,1);
    THPhandle.peak2=fit(THP(1,PeakStart:PeakEnd)',THP(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(THP(1,:)==1025.3,1);
    PeakEnd=find(THP(1,:)==1027.5,1);
    THPhandle.peak3=fit(THP(1,PeakStart:PeakEnd)',THP(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(THP(1,:)==1028.3,1);
    PeakEnd=find(THP(1,:)==1030.5,1);
    THPhandle.peak4=fit(THP(1,PeakStart:PeakEnd)',THP(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(THP(1,:)==1031.4,1);
    PeakEnd=find(THP(1,:)==1033.5,1);
    THPhandle.peak5=fit(THP(1,PeakStart:PeakEnd)',THP(2,PeakStart:PeakEnd)','gauss1');
    PeakStart=find(THP(1,:)==1034.5,1);
    PeakEnd=find(THP(1,:)==1035,1);
    THPhandle.peak6=fit(THP(1,PeakStart:PeakEnd)',THP(2,PeakStart:PeakEnd)','gauss1');
    THPhandle.THPhistdata=THP;
    syms x
    Func = (THPhandle.peak1.a1*exp(-((x-THPhandle.peak1.b1)/THPhandle.peak1.c1)^2))+(THPhandle.peak2.a1*exp(-((x-THPhandle.peak2.b1)/THPhandle.peak2.c1)^2))+(THPhandle.peak3.a1*exp(-((x-THPhandle.peak3.b1)/THPhandle.peak3.c1)^2))+(THPhandle.peak4.a1*exp(-((x-THPhandle.peak4.b1)/THPhandle.peak4.c1)^2))+(THPhandle.peak5.a1*exp(-((x-THPhandle.peak5.b1)/THPhandle.peak5.c1)^2))+(THPhandle.peak6.a1*exp(-((x-THPhandle.peak6.b1)/THPhandle.peak6.c1)^2));
    THPhandle.peaks(1,:) = xstart:0.01:xstop;
    THPhandle.peaks(2,:) = double(subs(Func,x,THPhandle.peaks(1,:)));
    plot(THPhandle.peaks(1,:),THPhandle.peaks(2,:),'LineWidth',3)
    clear x THP Func
end
set(gcf, 'Position', get(0, 'Screensize'));
%% Concentration graphs
figure
subplot(2,2,1)
plot(THPhandle.peaks(1,:),(THPhandle.peaks(2,:)/10)+HThandle.peaks(2,:),'LineWidth',3)
title('10%')

subplot(2,2,2)
plot(THPhandle.peaks(1,:),(THPhandle.peaks(2,:)/4)+HThandle.peaks(2,:),'LineWidth',3)
title('25%')

subplot(2,2,3)
plot(THPhandle.peaks(1,:),(THPhandle.peaks(2,:)/2)+HThandle.peaks(2,:),'LineWidth',3)
title('50%')

subplot(2,2,4)
plot(THPhandle.peaks(1,:),THPhandle.peaks(2,:)+HThandle.peaks(2,:),'LineWidth',3)
title('100%')

set(gcf, 'Position', get(0, 'Screensize'));
%% Hec1A - Under Construction
% figure
% for i =1:size(hec,1)
%     Y(i,:) = interp1(Xn,hec(i,Str:Stp),xbas:xstep:xson,'spline');
%     y(i)=max(Y(i,:));
%     x(i)=X(find(Y(i,:)==y(i),1));
% end
% histogram(x,edges,'Normalization','probability');
% clear i x y Y
% ylim([0 yson])
% xlim([xbas xson])
% title('HEC1A')
%% HeLa - Under Construction
% figure
% for i =1:size(hela,1)
%     Y(i,:) = interp1(Xn,hela(i,Str:Stp),xbas:xstep:xson,'spline');
%     y(i)=max(Y(i,:));
%     x(i)=X(find(Y(i,:)==y(i),1));
% end
% histogram(x,edges,'Normalization','probability');
% clear i x y Y
% ylim([0 yson])
% xlim([xbas xson])
% title('HeLa')
%% Clear extras
clear BinWidth edges gaussfit middles PeakEnd PeakStart Stp Str X Xn xstart xstep xstop ylimit