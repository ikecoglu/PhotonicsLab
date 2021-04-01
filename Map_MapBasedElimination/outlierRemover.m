%This function removes outliers from the data.
function [ed_data] = outlierRemover(data,list)
ed_data = [];
dataSize = size(data,1);
for i=1:dataSize
    if not(nnz(list==i))
        ed_data(end + 1,:) = data(i,:,2);
    end
end
end