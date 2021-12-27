function y = lorentz(param, x)
y = (param(1)./(2*pi.^2)) ./ ((x.^2)+(param(2).^2));