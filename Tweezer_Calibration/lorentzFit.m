function ParamForLorentz = lorentzFit(x,y)
for k = 0 : 2,
    for l = 0 : 2,
        eval(['s' num2str(k) num2str(l) ' = sum ((x .^ (2*' num2str(k) ')) .* (y .^ (' num2str(l) ')));']);
    end;
end;
p(1)= (s01 * s22 - s11 * s12) / (s02 * s22 - s12.^2); %a
p(2)= (s11 * s02 - s01 * s12) / (s02 * s22 - s12.^2); %b

lorentz = @(param, x) 1./(param(1)+(param(2).*(x.^2)));
fit_error = @(param) sum(((y - lorentz(param,x))/(lorentz(param,x)/sqrt(length(y)))).^2);
ParamForLorentz = fminsearch(fit_error, p);