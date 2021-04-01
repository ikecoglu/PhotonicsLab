%% Data prep
thp100 = [thp100_1; thp100_2; thp100_3]-pbs_mean;
ht100 = [ht100_1; ht100_2; ht100_3; ht100_4; ht100_5]-pbs_mean;
thp100=thp100(:,1:1131);
ht100=ht100(:,1:1131);

thp100_80 = thp100(1:11679,:);
ht100_80 = ht100(1:12214,:);
thp100_20 = thp100(11680:end,:);
ht100_20 = ht100(12215:end,:);
clear thp100 ht100
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
data=[ht50thp1_1;ht50thp1_2]-pbs_mean; data=data(:,1:1131)';
conf_ht50thp1=net(data);

data=[ht50thp10_1;ht50thp10_2;ht50thp10_3]-pbs_mean; data=data(:,1:1131)';
conf_ht50thp10=net(data);

data=[ht50thp25_1;ht50thp25_2]-pbs_mean;data=data(:,1:1131)';
conf_ht50thp25=net(data);

data=[ht50thp50_1]-pbs_mean;data=data(:,1:1131)';
conf_ht50thp50=net(data);

data=[thp50ht1_1;thp50ht1_2;thp50ht1_3]-pbs_mean;data=data(:,1:1131)';
conf_thp50ht1=net(data);

data=[thp50ht10_1;thp50ht10_2;thp50ht10_3;thp50ht10_4]-pbs_mean;data=data(:,1:1131)';
conf_thp50ht10=net(data);

data=[thp50ht25_1;thp50ht25_2;thp50ht25_3;thp50ht25_4]-pbs_mean;data=data(:,1:1131)';
conf_thp50ht25=net(data);

data=[thp50ht50_1;thp50ht50_2;thp50ht50_3;thp50ht50_4]-pbs_mean;data=data(:,1:1131)';
conf_thp50ht50=net(data);