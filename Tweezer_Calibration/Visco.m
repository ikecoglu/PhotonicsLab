r=0.5E-6;%m
d=1061.03295394597;%kg/m^3
ft=65000;%Hz
fc=[1:1000];
visc=((4.*d.*(ft^2).*pi.*(r^2))./(9.*fc)).*1000;
%%
plot(fc,visc);
xlabel('fc (Hz)')
ylabel('Visco. (mPa*s)')
ylim([0 5])