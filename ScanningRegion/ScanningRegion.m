clear; close all; clc;
%% Scanning Parameters
% 1 step = 256 ustep | 1 step = 2.5 um

StepSize = 8; % Step size to use after determining the region. In steps.
IntTime = 2e5; % integration time in terms of microsecond
num_of_average = 0; %number of spectrums to take average of in each location, no average = 0
BoxcarWidth = 1;
ROI = [800 950]; % ROI for plotting while scanning in nm

speed = 1000; % steps / s
uspeed = 1000; % steps / s

%% Region Determination Parameters

Size_X = 3000; % Estimated size of the sample in X direction in um
Size_Y = 3000; % Estimated size of the sample in X direction in um
nSplit = 10;

Treshold_region = [845, 855]; % Region of spectrum to use for thresholding in nm

IntTime_region = 1e5; % integration time in terms of microsecond
num_of_average_region = 0; %number of spectrums to take average of in each location, no average = 0

%% Spectrometer

wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();
wrapper.openAllSpectrometers();
wrapper.getName(0)
wl = wrapper.getWavelengths(0);
ROI_mask = and(ROI(2)>wl,wl>ROI(1));
if num_of_average_region > 0
    wrapper.setScansToAverage(0,num_of_average_region);
end
wrapper.setIntegrationTime(0,IntTime_region);
wrapper.getCorrectForElectricalDark(0);
wrapper.getCorrectForDetectorNonlinearity(0);
wrapper.setBoxcarWidth(0,BoxcarWidth);

%% Stage

[~,maxArraySize]=computer;
is64bit = maxArraySize > 2^31;
if (ispc)
    if (is64bit)
        disp('Using 64-bit version')
    else
        disp('Using 32-bit version')
    end
elseif ismac
    disp('Using mac version')
elseif isunix
    disp('Using unix version, check your compilers')
end

if not(libisloaded('libximc'))
    disp('Loading library')
    if ispc
        addpath(fullfile(pwd,'./ximc-2.10.5/ximc/win64/wrappers/matlab/'));
        if (is64bit)
            addpath(fullfile(pwd,'./ximc-2.10.5/ximc/win64/'));
            [notfound,warnings] = loadlibrary('libximc.dll', @ximcm)
        else
            addpath(fullfile(pwd,'./ximc-2.10.5/ximc/win32/'));
            [notfound, warnings] = loadlibrary('libximc.dll', 'ximcm.h', 'addheader', 'ximc.h')
        end
    elseif ismac
        addpath(fullfile(pwd,'./ximc-2.10.5/ximc/'));
        [notfound, warnings] = loadlibrary('libximc.framework/libximc', 'ximcm.h', 'mfilename', 'ximcm.m', 'includepath', 'libximc.framework/Versions/Current/Headers', 'addheader', 'ximc.h')
    elseif isunix
        [notfound, warnings] = loadlibrary('libximc.so', 'ximcm.h', 'addheader', 'ximc.h')
    end
end

% Set bindy (network) keyfile. Must be called before any call to "enumerate_devices" or "open_device" if you
% wish to use network-attached controllers. Accepts both absolute and relative paths, relative paths are resolved
% relative to the process working directory. If you do not need network devices then "set_bindy_key" is optional.
calllib('libximc','set_bindy_key', './ximc-2.10.5/ximc/win32/keyfile.sqlite')

probe_flags = 1 + 4; % ENUMERATE_PROBE and ENUMERATE_NETWORK flags used
enum_hints = 'addr=192.168.1.1,172.16.2.3';
% enum_hints = 'addr='; % Use this hint string for broadcast enumeration
device_names = ximc_enumerate_devices_wrap(probe_flags, enum_hints);
devices_count = size(device_names,2);

if devices_count == 0
    disp('No devices found')
    return
end
for i=1:devices_count
    disp(['Found device: ', device_names{1,i}]);
end

device_name_Y = device_names{1,1};
% disp(['Using device name ', device_name1]);
device_name_X = device_names{1,2};
% disp(['Using device name ', device_name2]);

device_id_Y = calllib('libximc','open_device', device_name_Y);
% disp(['Using device id ', num2str(device_id1)]);
device_id_X = calllib('libximc','open_device', device_name_X);
% disp(['Using device id ', num2str(device_id2)]);

calb = struct();
calb.A = 0.1; % arbitrary choice for example, set by user in real scenarios
calb.MicrostepMode = 4; % == MICROSTEP_MODE_FRAC_8
state_calb_s1 = ximc_get_status_calb(device_id_Y, calb);
state_calb_s2 = ximc_get_status_calb(device_id_X, calb);
% disp('Status calb:'); disp(state_calb_s1);
% disp('Status calb:'); disp(state_calb_s2);

% disp('Set microstep mode to 256...');
ximc_set_microstep_256(device_id_Y);
ximc_set_microstep_256(device_id_X);

% disp('Change speed...')

ximc_set_speed(device_id_Y, speed , uspeed);
ximc_set_speed(device_id_X, speed , uspeed);

%% Save the sample center

% Determine starting position

LX = round(Size_X/2.5);
LY = round(Size_Y/2.5);

state_Y = ximc_get_status(device_id_Y);
state_X = ximc_get_status(device_id_X);

center_position_Y = state_Y.CurPosition;
center_uposition_Y = state_Y.uCurPosition;
center_position_X = state_X.CurPosition;
center_uposition_X = state_X.uCurPosition;

result = calllib('libximc','command_move', device_id_Y, center_position_Y, center_uposition_Y);
result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);

result = calllib('libximc','command_move', device_id_X, center_position_X, center_uposition_X);
result = calllib('libximc','command_wait_for_stop',device_id_X, 10);

%% Show region - to see if there is any part of the sample outside and select treshold

tic

X_min = center_position_X - LX;
X_max = center_position_X + LX;

Y_min = center_position_Y - LY;
Y_max = center_position_Y + LY;

X = round(linspace(X_min, X_max, nSplit));
Y = round(linspace(Y_min, Y_max, nSplit));
spectrum = wrapper.getSpectrum(0)'; %trash spectrum
background = wrapper.getSpectrum(0)';
% background = zeros(1,length(spectrum));

Map = nan(length(Y),length(X));

for y = 1:length(Y)
    clc; disp(round(100*y/length(Y)))
    
    result = calllib('libximc','command_move', device_id_Y, Y(y), center_uposition_Y);
    result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
    
    for x = 1:length(X)
        
        result = calllib('libximc','command_move', device_id_X, X(x),center_uposition_X);
        result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
        
        spectrum = wrapper.getSpectrum(0)';
        spectrum = spectrum - background;
        
        Map(y,x) = round(mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2)))));
    end
    if mod(y,2)==0
        Map(y,:) = flip(Map(y,:));
    end
    X = flip(X);
end

subplot(1,2,1)
imagesc(Map)
set(gcf, 'Position', get(0, 'Screensize'));

list = unique(Map);
h = subplot(1,2,2);
plot(list)
[i,~] = getpts(h);
Threshold = list(round(i))

close all

% Region Determination

for iteration = 1:2
    
    X = round(linspace(X_min, X_max, nSplit));
    Y = round(linspace(Y_min, Y_max, nSplit));
    spectrum = wrapper.getSpectrum(0)'; %trash spectrum
    signal = 0;
    
    for y = 1:nSplit
        
        result = calllib('libximc','command_move', device_id_Y, Y(y), center_uposition_Y);
        result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
        
        for x = 1:nSplit
            
            result = calllib('libximc','command_move', device_id_X, X(x), center_uposition_X);
            result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
            
            spectrum = wrapper.getSpectrum(0)';
            spectrum = spectrum - background;
            spectrum = mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2))));
            
            if round(spectrum) > Threshold
                if y==1
                    Y_min = Y(1)
                else
                    Y_min = Y(y-1)
                end
                signal = 1;
                break
            end
        end
        if signal
            break
        end
        X = flip(X);
    end
    
    Y = round(linspace(Y_min, Y_max, nSplit));
    signal = 0;
    
    for y = nSplit:-1:1
        
        result = calllib('libximc','command_move', device_id_Y, Y(y), center_uposition_Y);
        result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
        
        for x = 1:nSplit
            
            result = calllib('libximc','command_move', device_id_X, X(x), center_uposition_X);
            result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
            
            spectrum = wrapper.getSpectrum(0)';
            spectrum = spectrum - background;
            spectrum = mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2))));
            
            if round(spectrum) > Threshold
                if y==length(Y)
                    Y_max = Y(y)
                else
                    Y_max = Y(y+1)
                end
                signal = 1;
                break
            end
        end
        if signal
            break
        end
        X = flip(X);
    end
    
    Y = round(linspace(Y_min, Y_max, nSplit));
    X = round(linspace(X_min, X_max, nSplit));
    signal = 0;
    
    for x = 1:nSplit
        
        result = calllib('libximc','command_move', device_id_X, X(x), center_uposition_X);
        result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
        
        for y = 1:nSplit
            
            result = calllib('libximc','command_move', device_id_Y, Y(y), center_uposition_Y);
            result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
            
            spectrum = wrapper.getSpectrum(0)';
            spectrum = spectrum - background;
            spectrum = mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2))));
            
            if round(spectrum) > Threshold
                if x==1
                    X_min = X(1)
                else
                    X_min = X(x-1)
                end
                signal = 1;
                break
            end
        end
        if signal
            break
        end
        Y = flip(Y);
    end
    
    X = round(linspace(X_min, X_max, nSplit));
    signal = 0;
    
    for x = nSplit:-1:1
        
        result = calllib('libximc','command_move', device_id_X, X(x), center_uposition_X);
        result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
        
        for y = 1:nSplit
            
            result = calllib('libximc','command_move', device_id_Y, Y(y), center_uposition_Y);
            result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
            
            spectrum = wrapper.getSpectrum(0)';
            spectrum = spectrum - background;
            spectrum = mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2))));
            
            if round(spectrum) > Threshold
                if x==length(X)
                    X_max = X(x)
                else
                    X_max = X(x+1)
                end
                signal = 1;
                break
            end
        end
        if signal
            break
        end
        Y = flip(Y);
    end
    
end

% Fast Preliminary Scanning of The Determined Region

X = round(linspace(X_min, X_max, nSplit));
Y = round(linspace(Y_min, Y_max, nSplit));
spectrum = wrapper.getSpectrum(0)'; %trash spectrum
Map = nan(length(Y),length(X));

for y = 1:length(Y)
    clc; disp(round(100*y/length(Y)))
    
    result = calllib('libximc','command_move', device_id_Y, Y(y), center_uposition_Y);
    result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
    
    for x = 1:length(X)
        
        result = calllib('libximc','command_move', device_id_X, X(x), center_uposition_X);
        result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
        
        spectrum = wrapper.getSpectrum(0)';
        spectrum = spectrum - background;
        Map(y,x) = mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2))));
    end
    if mod(y,2)==0
        Map(y,:) = flip(Map(y,:));
    end
    X = flip(X);
end

figure
imagesc(round(Map))

clc; fprintf("Starting position: X = %d, Y = %d\n", X_min, Y_min)
fprintf("Number of steps X = %d ; Number of steps Y = %d\n", ceil((X_max-X_min)/StepSize), ceil((Y_max-Y_min)/StepSize))

toc
%% Scanning

[FileName,PathName] = uiputfile('C:\Users\PAM\Desktop\raman measurements\*.*');

% Update Spectrometer Settings
if num_of_average > 0
    wrapper.setScansToAverage(0,num_of_average);
end
wrapper.setIntegrationTime(0,IntTime);

X = X_min: StepSize : X_max;
Y = Y_min: StepSize : Y_max;

spectrum = wrapper.getSpectrum(0)'; %trash spectrum
RawData = nan(length(Y), length(X), length(wl));
max_spec = zeros(1,length(wl));
min_spec = 1e6*ones(1,length(wl));

figure
set(gcf, 'Position', get(0, 'Screensize'));

tic
for y = 1:length(Y)
    clc; disp(round(100*y/length(Y)))
    
    result = calllib('libximc','command_move', device_id_Y, Y(y), center_uposition_Y);
    result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
    
    for x = 1:length(X)
        
        result = calllib('libximc','command_move', device_id_X, X(x), center_uposition_X);
        result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
        
        spectrum = wrapper.getSpectrum(0)';
        
        log_max = spectrum > max_spec;
        log_min = spectrum < min_spec;
        max_spec(log_max) = spectrum(log_max);
        min_spec(log_min) = spectrum(log_min);
        plot(wl(ROI_mask), max_spec(ROI_mask), wl(ROI_mask), spectrum(ROI_mask), wl(ROI_mask), min_spec(ROI_mask), 'LineWidth', 1.5);
        legend('Max', 'Current', 'Min')
        pause(0.0001)
        
        RawData(y,x,:) = spectrum;
    end
    if mod(y,2)==0
        RawData(y,:,:) = flip(RawData(y,:,:));
    end
    X = flip(X);
end

save(fullfile(PathName,[FileName, '.mat']), 'wl', 'RawData', 'StepSize','IntTime')

figure
MeanMap = mean(RawData(:,:,and(wl>=Treshold_region(1), wl<=Treshold_region(2))),3);
imagesc(MeanMap)
caxis([min(MeanMap(~isoutlier(MeanMap))) max(MeanMap(~isoutlier(MeanMap)))])
pbaspect([length(X) length(Y) 1])
set(gcf,'renderer','painters');
print(gcf,fullfile(PathName,[FileName, '.png']),'-dpng','-r600');
clc; disp('Done!')
toc
%% Closing protocol

% Close stage
device_id_ptr_Y = libpointer('int32Ptr', device_id_Y);
device_id_ptr_X = libpointer('int32Ptr', device_id_X);
calllib('libximc','close_device', device_id_ptr_Y);
calllib('libximc','close_device', device_id_ptr_X);

% Close spectrometer
wrapper.closeAllSpectrometers();

disp('Done');

% when needed
% unloadlibrary('libximc');
