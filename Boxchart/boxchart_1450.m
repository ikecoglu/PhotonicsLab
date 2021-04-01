box_labels=[repmat(1,50,1);repmat(10,50,1);repmat(25,50,1);repmat(50,50,1)];
boxplot(box_data,box_labels,'Symbol','r.','Positions',[1 10 25 50])
hold on
x=[1 10 25 50];
plot(x,box_mean,'rs')
% sp=interp1([1 10 25 50],box_mean,[1:0.001:50],'cubic');
% plot([1:0.001:50],sp,'g','LineWidth',3)
% plot(box_fit(:,1),box_fit(:,2),'b','LineWidth',3)
title('Peak Position Around 1600 cm^{-1}')
xlabel('Concentration of HT-1080 (%)','FontSize',14)
ylabel('Raman Shift (cm^{-1})','FontSize',14)
set(gca,'FontSize',14)
% ylim([1445 1460])
ylim([1590 1610])
% ylim([1065 1100])
% ylim([1059.8 1080])
% ylim([1020 1030])
% ylim([1501 1509])
%%
fitXdata=[1:0.001:50];
fitYdata=fittedmodel.a*(fitXdata.^fittedmodel.b);
plot(fitXdata,fitYdata,'LineWidth',3)
%%
fitXdata=[1:0.001:50];
fitYdata=fittedmodel.p2+(fitXdata.*fittedmodel.p1);
plot(fitXdata,fitYdata,'LineWidth',3)