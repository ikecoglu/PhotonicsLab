function [ed_data] = eliminationfunc(data,trs)
ed_data = data(:,:,2);
L1 = 1;L2 = 2;
while L1 ~= L2
    L1 = length(ed_data);
    [coeff,score] = pca(ed_data);
    z = zscore(score(:,1));
    ed_data = ed_data(not(or(z<-trs,z>trs)),:);
    L2 = length(ed_data);
end
figure
plot(670:1800,ed_data);
figure
plot(score(:,1), score(:,2),'*');
end