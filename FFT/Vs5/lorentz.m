function y = lorentz(param, x)
y = 1./(param(1)+(param(2).*(x.^2)));