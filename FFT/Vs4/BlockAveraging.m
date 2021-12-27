function CompressedData = BlockAveraging(data,WindowSize)
l=length(data);
m=mod(l,WindowSize);
CompressedSize=(l-m)/WindowSize;
CompressedData=zeros(1,CompressedSize);
for i=1:CompressedSize
    CompressedData(i)=mean(data((WindowSize*(i-1))+1:i*WindowSize));
end
if m~=0
    CompressedData=[CompressedData,mean(data(l-WindowSize+1:end))];
end