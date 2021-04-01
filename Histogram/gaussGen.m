function g = gaussGen(x, F,center)
Const = 2*sqrt(log(2)*2)/(F*sqrt(2*pi));
Const2 = F^2/(2*log(2));
g =Const.*exp(-(x-center).^2./Const2) ;