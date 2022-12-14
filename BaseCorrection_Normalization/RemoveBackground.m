function [RS] = RemoveBackground(Measured_Spectrum, Background, Poly_order)

% This function is based on the method described in: Beier, Brooke D., 
% and Andrew J. Berger. “Method for Automated Background Subtraction from 
% Raman Spectra Containing Known Contaminants.” Analyst 134, no. 6 (2009): 
% 1198–1202. https://doi.org/10.1039/B821856K.

warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale')

eps = 0.1;
Spectrum_length = size(Measured_Spectrum, 2);
if mod(Spectrum_length,2)==1
    Calx = [(1-Spectrum_length)/2 : (Spectrum_length-1)/2];
else
    Calx = [-Spectrum_length/2 + 1 : Spectrum_length/2];
end

X = Background;
DataSize = size(Measured_Spectrum, 1);
RS = nan(DataSize, length(Calx));
tic
time = toc;
for k = 1:DataSize

%     clc; fprintf('%.2f %% - Time taken: %.0f s - Estimated Time Left: %.0f s\n', k*100/DataSize, time, time*(DataSize-k)/k);

    S = Measured_Spectrum(k,:);
    B(1,:) = S;

    p = polyfit(X, S, 1);
    Cg = p(1);

    err = 1e10;
    i = 1;
    while and(err>eps, i<=100)

        M_h = @(c)M(c,B(i,:),X, Calx, Poly_order);
        C = fminsearch(M_h, Cg);

        F = B(i,:) - C * X;
        PolyModel = polyval(polyfit(Calx, F, Poly_order), Calx);
        Btd(i,:) = C * X + PolyModel;

        B(i+1,:) = min([B(i,:); Btd(i,:)]);
        Cg = C;
        i = i+1;

        err = sqrt(sum((B(end, :)-B(end-1, :)).^2));
    end

    RS(k,:) = S - C * X - PolyModel;
    B = []; Btd = [];
    time = toc;
end

    function out = M(c, B, X, Calx, Poly_order)

        F = B - c .* X;
        p = polyfit(Calx, F, Poly_order);
        Fres = F - polyval(p,Calx);
        out = sum(Fres.^2);

    end


end

