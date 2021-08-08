function [BCInt, y] = base_correct(basePoints, Calx, CalInt, mode)
% a function for creating and subtracting a base line.
for i=1:size(basePoints,2)
    indx(i)=find(Calx==basePoints(i));
end
dataSize = size(CalInt,1);
for i= 1:dataSize
    clc;
    disp(strcat("Base correction: ", int2str((i/dataSize)*100), "%"));
    y(i,:)=interp1(basePoints, CalInt(i, indx), Calx, mode);
    for k=1:size(CalInt,2)  
        BCInt(i,k)=CalInt(i,k)-y(i,k);
    end
end
end