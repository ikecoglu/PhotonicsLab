function [fitresult, gof] = Fit(Rx, Ry)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( Rx, Ry );
% Set up fittype and options.
ft = fittype( 'gauss1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0];
opts.StartPoint = [180950.32 785.126 0.529647215776489];
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
