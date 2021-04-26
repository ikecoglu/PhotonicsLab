close all
for i=1:100
    plot(CalX,S1(i,:));xlim([660 2310]);ylim([-100 1500])
%     set(gcf, 'Position', get(0, 'Screensize'));
    set(gcf,'renderer','painters');
    print(gcf,strcat('C:\Users\ibrah\Desktop\A\',num2str(i),'.jpg'),'-djpeg','-r600');close
end
%%
r=1.5E-6;%m
d=1061.03295394597;%kg/m^3
ft=3600;%Hz
fc=43;%Hz
vmin=((4*d*(ft^2)*pi*(r^2))/(9*fc))*1000