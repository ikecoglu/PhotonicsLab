function [spec] = RamanShiftConverter(spec)

%interval in which Rayleigh fit happens
Rx=spec(1,1:10,1);
Ry=spec(1,1:10,2);

[f,~] = Fit(Rx, Ry);

%     plot(Rx,Ry),hold on;plot(f);
%     disp(f.b1)
spec(1,:,1)=((1/f.b1)-(1./spec(1,:,1))).*1e7;
end