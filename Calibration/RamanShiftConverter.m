function [spec] = RamanShiftConverter(dataSize,spec)
for i=1:dataSize
    clc;
    disp(strcat("Raman shift conversion: ",int2str((i/dataSize)*100),"%"));
    
    %interval in which Rayleigh fit happens
    Rx=spec(i,1:10,1);
    Ry=spec(i,1:10,2);
    
    [f,~] = Fit(Rx, Ry);
    
%     plot(Rx,Ry),hold on;plot(f);
%     disp(f.b1)
    spec(i,:,1)=((1/f.b1)-(1./spec(i,:,1))).*1e7;
end