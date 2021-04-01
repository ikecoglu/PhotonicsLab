%% Data prep
thp100pbs = thp100 - pbs_mean;
ht100pbs = ht100 - pbs_mean;
thp100pbs=thp100pbs(:,1:1131);
ht100pbs=ht100pbs(:,1:1131);

thp100_80 = thp100pbs(1:11679,:);
ht100_80 = ht100pbs(1:12214,:);
thp100_20 = thp100pbs(11680:end,:);
ht100_20 = ht100pbs(12215:end,:);
clear thp100pbs ht100pbs
%% Training
data = [ht100_80; thp100_80]';
tdat(1,:)=[repmat([1],size(ht100_80,1),1)',repmat([0],size(thp100_80,1),1)'];%ht
tdat(2,:)=[repmat([0],size(ht100_80,1),1)',repmat([1],size(thp100_80,1),1)'];%thp
net = patternnet(10);
[net,tr] = train(net,data,tdat);
nntraintool
plotperform(tr)
%% Test
testdata = [ht100_20; thp100_20]';
testtdat(1,:)=[repmat([1],size(ht100_20,1),1)',repmat([0],size(thp100_20,1),1)'];%ht
testtdat(2,:)=[repmat([0],size(ht100_20,1),1)',repmat([1],size(thp100_20,1),1)'];%thp
testY = net(testdata);
figure,plotconfusion(testtdat,testY);
figure,plotroc(testtdat,testY);
%%
data=thp50ht1-pbs_mean;data=data(:,1:1131)';
conf_thp50ht1=net(data);

data=thp50ht10-pbs_mean;data=data(:,1:1131)';
conf_thp50ht10=net(data);

data=thp50ht25-pbs_mean;data=data(:,1:1131)';
conf_thp50ht25=net(data);

data=thp50ht50-pbs_mean;data=data(:,1:1131)';
conf_thp50ht50=net(data);
%%
subplot(2,2,1)
histogram(conf_thp50ht1(1,:),'Normalization','probability')
title('1')
subplot(2,2,2)
histogram(conf_thp50ht10(1,:),'Normalization','probability')
title('10')
subplot(2,2,3)
histogram(conf_thp50ht25(1,:),'Normalization','probability')
title('25')
subplot(2,2,4)
histogram(conf_thp50ht50(1,:),'Normalization','probability')
title('50')