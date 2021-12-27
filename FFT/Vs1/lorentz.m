function y = lorentz(param, x)
y = param(1) ./ ((x-param(2)).^2 + param(3));