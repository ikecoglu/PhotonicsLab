clear all;close all;clc;load('C:\Users\ibrah\Desktop\Photonics_Workspace\Edited_Concentration.mat')
%% Settings
xstart=1020; xstep=0.1; xstop=1035; ystop=0.5;
BinWidth = 1;
% User input ends here --------------------------------------------------
edges = [xstart-(BinWidth/2):BinWidth:xstop+(BinWidth/2)];
middles = [xstart:BinWidth:xstop];
Str = find(Calx==xstart);Stp = find(Calx==xstop);Xn=Calx(Str:Stp);X=xstart:xstep:xstop;
%% THP 10%
subplot(2,2,1)
for i =1:size(thp10,1)
    Y(i,:) = interp1(Xn,thp10(i,Str:Stp),xstart:xstep:xstop,'spline');
    y(i)=max(Y(i,:));
    x(i)=X(find(Y(i,:)==y(i),1));
end
clear THP10
h1=histogram(x,edges,'Normalization','probability');
Concentration.THP10(1,:)=middles;
Concentration.THP10(2,:)=h1.Values;
title('THP10')
ylim([0 ystop])
xlim([xstart xstop])
clear i x y Y h1
%% THP 25%
subplot(2,2,2)
for i =1:size(thp25,1)
    Y(i,:) = interp1(Xn,thp25(i,Str:Stp),xstart:xstep:xstop,'spline');
    y(i)=max(Y(i,:));
    x(i)=X(find(Y(i,:)==y(i),1)); 
end
clear THP25
h2=histogram(x,edges,'Normalization','probability');
Concentration.THP25(1,:)=middles;
Concentration.THP25(2,:)=h2.Values;
ylim([0 ystop])
xlim([xstart xstop])
title('THP25')
clear i x y Y h2
%% THP 50%
subplot(2,2,3)
for i =1:size(thp50,1)
    Y(i,:) = interp1(Xn,thp50(i,Str:Stp),xstart:xstep:xstop,'spline');
    y(i)=max(Y(i,:));
    x(i)=X(find(Y(i,:)==y(i),1));
end
clear THP50
h3=histogram(x,edges,'Normalization','probability');
Concentration.THP50(1,:)=middles;
Concentration.THP50(2,:)=h3.Values;
ylim([0 ystop])
xlim([xstart xstop])
title('THP50')
clear i x y Y h3
%% THP 100%
subplot(2,2,4)
for i =1:size(thp100,1)
    Y(i,:) = interp1(Xn,thp100(i,Str:Stp),xstart:xstep:xstop,'spline');
    y(i)=max(Y(i,:));
    x(i)=X(find(Y(i,:)==y(i),1));
end
clear THP100
h4=histogram(x,edges,'Normalization','probability');
Concentration.THP100(1,:)=middles;
Concentration.THP100(2,:)=h4.Values;
ylim([0 ystop])
xlim([xstart xstop])
title('THP100')
clear i x y Y h4
%%
set(gcf, 'Position', get(0, 'Screensize'));
clear BinWidth edges middles Stp Str xstart xstep xstop ystop X Xn