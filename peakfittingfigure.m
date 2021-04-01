%% thp100_1100
plot(thp100_1100(:,1),thp100_1100(:,2),'k','LineWidth',3)
hold on
plot(thp100_1100(:,1),thp100_1100(:,3),'r--','LineWidth',3)
hold on
for i=4:13
    plot(thp100_1100(:,1),thp100_1100(:,i),'LineWidth',2)
    hold on
end
title('THP-1')
legend('Original Spectrum','Fitted Line','FontSize',14)
xlabel('Raman Shift (cm^{-1})','FontSize',14)
ylabel('Normalized Intensity (a.u.)','FontSize',14)
set(gca,'FontSize',14)
xlim([975 1089])
ylim([-0.05 0.5])
%% ht100_1100
plot(ht100_1100(:,1),ht100_1100(:,2),'k','LineWidth',3)
hold on
plot(ht100_1100(:,1),ht100_1100(:,3),'r--','LineWidth',3)
hold on
for i=4:13
    plot(ht100_1100(:,1),ht100_1100(:,i),'LineWidth',2)
    hold on
end
title('HT-1080')
legend('Original Spectrum','Fitted Line','FontSize',16)
xlabel('Raman Shift (cm^{-1})','FontSize',14)
ylabel('Normalized Intensity (a.u.)','FontSize',14)
set(gca,'FontSize',14)
xlim([975 1089])
ylim([-0.05 0.5])
%% thp100_1450
plot(thp100_1450(:,1),thp100_1450(:,2),'k','LineWidth',3)
hold on
plot(thp100_1450(:,1),thp100_1450(:,3),'r--','LineWidth',3)
hold on
for i=4:18
    plot(thp100_1450(:,1),thp100_1450(:,i),'LineWidth',2)
    hold on
end
title('THP-1')
legend('Original Spectrum','Fitted Line','FontSize',14)
xlabel('Raman Shift (cm^{-1})','FontSize',14)
ylabel('Normalized Intensity (a.u.)','FontSize',14)
set(gca,'FontSize',14)
xlim([1411 1673])
ylim([-0.05 0.5])
%% ht100_1450
plot(ht100_1450(:,1),ht100_1450(:,2),'k','LineWidth',3)
hold on
plot(ht100_1450(:,1),ht100_1450(:,3),'r--','LineWidth',3)
hold on
for i=4:18
    plot(ht100_1450(:,1),ht100_1450(:,i),'LineWidth',2)
    hold on
end
title('HT-1080')
legend('Original Spectrum','Fitted Line','FontSize',14)
xlabel('Raman Shift (cm^{-1})','FontSize',14)
ylabel('Normalized Intensity (a.u.)','FontSize',14)
set(gca,'FontSize',14)
xlim([1411 1673])
ylim([-0.05 0.5])