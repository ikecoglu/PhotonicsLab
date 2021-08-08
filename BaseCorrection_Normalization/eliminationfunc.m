function [data] = eliminationfunc(data, trs)
L1 = 1;L2 = 2; OrjSize = size(data, 1);
while L1 ~= L2
    L1 = size(data, 1);
    [coeff, score] = pca(data);
    z = zscore(score(:,1));
    data = data(not(or(z<-trs,z>trs)),:);
    L2 = size(data, 1);
end
clc
disp(['Orj size: ' num2str(OrjSize) ' After elimination size: ' num2str(L2)])
% figure
% plot(score(:,1), score(:,2),'.');
end