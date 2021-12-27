function ParamForLorentz = lorentzFit(x,y)
for k = 0 : 2,
for l = 0 : 2,
eval(['s' num2str(k) num2str(l) ' = sum ((x .^ (2*' num2str(k) ')) .* (y .^ (' num2str(l) ')));']);
end;
end;
a   = (s01 * s22 - s11 * s12) / (s02 * s22 - s12.^2);
b   = (s11 * s02 - s01 * s12) / (s02 * s22 - s12.^2);
p(1)   = (1/b) * 2 * (pi.^2); %D
p(2) = sqrt(a/b); %fc

lorentz = @(param, x) (param(1)./(2*pi.^2)) ./ ((x.^2)+(param(2).^2));
fit_error = @(param) sum((y - lorentz(param, x)).^2);
ParamForLorentz = fminsearch(fit_error, p);