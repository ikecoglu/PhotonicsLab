clear all;close all;clc;load('TestData.mat');data.x=x;data.y=y;data.z=z;clear x y z
fSampling=50000; %Sampling frequency(Hz)
kB=1.38e-23; % Boltzmann constant [m^2kg/s^2K]
T=273.15+20; % Temperature [K]
r=0.5E-6;    % Particle radius [m]
freqMin=100;
freqMax=2000;
WindowSize=15;
v=0.00002414*10^(247.8/(-140+T));  % Water dynamic viscosity [Pa*s]
gamma=6*pi*r*v; %Drag/friction coefficient

n=length(data.x);
% dt=X.t(2);
% freq=(1/(dt*n))*(-n/2:n/2-1);
dt=1/fSampling;
freq=(1/(dt*n))*(-n/2+1:n/2);
L=floor(n/2)+1:n;
freq=freq(L);
freq=BlockAveraging(freq,WindowSize);
%% PSD X
xhat=fft(data.x,n);
xhat=fftshift(xhat);
PSDx=xhat.*conj(xhat)/n;
PSDx=2*PSDx(L)';
PSDx=BlockAveraging(PSDx,WindowSize);
figure
subplot(2,2,1)
histfit(data.x,100);
xlabel('Position')minsearch(fit_err
ylabel('Count')
subplot(2,2,3)
plot(freq/1000,PSDx);
xlabel('Frequency (kHz)')
ylabel('PSD')
sgtitle('X')
set(gcf, 'Position', get(0, 'Screensize'));

x = freq;
indMin=find(x>freqMin,1);indMax=find(x<freqMax,1,'last');x=x(indMin:indMax);
y = PSDx;
y=y(indMin:indMax);
subplot(2,2,2)
x_grid = linspace(min(x), max(x), 1000);
a=lorentzFit(x,y);
loglog(freq, PSDx);hold on;
loglog(x_grid, lorentz(a, x_grid), 'r', 'LineWidth',3);
xlim([min(freq) max(freq)])
xlabel('Frequency (Hz)');
ylabel('PSD');
legend('PSD', 'fit')
subplot(2,2,4)
plot(x/1000,y./lorentz(a, x),'.','MarkerSize',10);hold on;
plot([min(x)/1000 max(x)/1000],[1 1],'--k', 'LineWidth',2);
xlim([min(x)/1000 max(x)/1000])
xlabel('Frequency (kHz)');
ylabel('Data / Fit');

Pwsx.D=(2*(pi^2))/(n*dt*a(2));
Pwsx.fc=sqrt(a(1)/a(2));
Pwsx.kx=2*pi*Pwsx.fc*gamma; %[PN/um]
annotation('textbox',[0.78 0.45 0.1 0.08],'String',{strcat('fc = ',num2str(Pwsx.fc),' Hz')},'FontSize',14,'FontName','Calibri','LineWidth',2,'BackgroundColor',[0.9  0.9 0.9]);
clear x y x_grid indMin indMax a