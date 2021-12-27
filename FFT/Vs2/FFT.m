clear all;close all;clc;load('TestData.mat');data.x=x;data.y=y;data.z=z;clear x y z
fSampling=50000; %Sampling frequency(Hz)
kB=1.38e-23; % Boltzmann constant [m^2kg/s^2K]
T=273.15+20; % Temperature [K]
r=0.5E-6;    % Particle radius [m]
freqMin=3;   %dB
freqMax=70;   %dB
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
%% PSD X
xhat=fft(data.x,n);
xhat=fftshift(xhat);
PSDx=xhat.*conj(xhat)/n;
PSDx=PSDx(L)';
PSDx=BlockAveraging(PSDx,WindowSize);
freq=BlockAveraging(freq,WindowSize);
figure
subplot(2,2,1)
histfit(data.x,100);
xlabel('Position')
ylabel('Count')
subplot(2,2,3)
plot(freq/1000,PSDx);
xlabel('Frequency (kHz)')
ylabel('PSD')
sgtitle('X')
set(gcf, 'Position', get(0, 'Screensize'));

x = log(freq);indMin=find(x>freqMin,1);indMax=find(x<freqMax,1,'last');x=x(indMin:indMax);
y = log(PSDx);y=y(indMin:indMax);
subplot(1,2,2)
x_grid = linspace(min(x), max(x), 1000);
a=lorentzFit(x,y);
plot(log(freq), log(PSDx), x_grid, lorentz(a, x_grid), 'r');
xlabel('Frequency');
ylabel('PSD');
legend('PSD', 'fit')
Pwsx.D=a(1);
Pwsx.fc=abs(a(2));
Pwsx.kx=2*pi*Pwsx.fc*gamma; %[PN/um]
clear x y x_grid indMin indMax a