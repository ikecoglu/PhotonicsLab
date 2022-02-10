function [data_out, data_out_base] = MSCfunc(data_in)
mean_spectrum = mean(data_in, 1);
spectrumNumber = size(data_in, 1);
spectrumLength = size(data_in, 2);
fit_coeff = zeros(spectrumNumber, 2);
data_out = zeros(spectrumNumber,spectrumLength);
data_out_base = zeros(spectrumNumber,spectrumLength);
for i=1:spectrumNumber
    fit_coeff(i,:) = polyfit(mean_spectrum, data_in(i,:), 1);
    data_out(i,:) = (data_in(i,:) - fit_coeff(i,2)) ./ fit_coeff(i,1);
    data_out_base(i,:) = data_out(i,:) - min(data_out(i,:));
end
end