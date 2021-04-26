function value = vmin(fc)
r=200E-9;%m
d=1061.03295394597;%kg/m^3
% d=1000;
ft=65000;%Hz
value=((4.*d.*(ft^2).*pi.*(r^2))./(9.*fc)).*1000;