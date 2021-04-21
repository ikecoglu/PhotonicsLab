function [spec] = RamanShiftConverter(dataSize,spec)
for i=1:dataSize
    clc;
    disp(strcat("Raman shift conversion: ",int2str((i/dataSize)*100),"%"));
    Rx=spec(i,1:20,1);
    Ry=spec(i,1:20,2);
    [f,~] = Fit(Rx, Ry);
%       plot(f);
%       hold on;
   for k=1:size(spec,2)
      spec(i,k,1)=((1/f.b1)-(1/spec(i,k,1)))*1e7;
   end
end