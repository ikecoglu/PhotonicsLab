function [NormInt] = normalization(BCInt)
dataSize = size(BCInt,1);
for i= 1:dataSize
    clc;
    disp(strcat("Normalizing data: ",int2str((i/dataSize)*100),"%"));
    NormInt(i,:)=BCInt(i,:)/norm(BCInt(i,:));
end