clear; close all; clc;
%% Scanning Parameters
% 1 step = 256 ustep | 1 step = 2.5 um

StepSize = 8; % Step size to use after determining the region. In steps.
IntTime = 3e5; % integration time in terms of microsecond
num_of_average = 0; %number of spectrums to take average of in each location, no average = 0
BoxcarWidth = 1; 

speed = 1000; % steps / s
uspeed = 1000; % steps / s

%% Region Determination Parameters

LX = 3500; % Max value of X length in steps, for the initial scan
LY = 2000; % Max value of Y length in steps, for the initial scan
nIteration = 3; % Number of times the regions is being shrunk
nSplit = 10;

Treshold_region = [810, 830]; %in nm

IntTime_region = 1e5; % integration time in terms of microsecond
num_of_average_region = 2; %number of spectrums to take average of in each location, no average = 0

%% Spectrometer

wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();
wrapper.openAllSpectrometers();
wrapper.getName(0)
wl = wrapper.getWavelengths(0);
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

state_Y = ximc_get_status(device_id_Y);
% disp('Status:'); disp(state_s1);
state_X = ximc_get_status(device_id_X);
% disp('Status:'); disp(state_s2);

%% Move from sample center to starting position

% Determine starting position
start_position_Y = state_Y.CurPosition-LY/2;
start_uposition_Y = state_Y.uCurPosition;
start_position_X = state_X.CurPosition-LX/2;
start_uposition_X = state_X.uCurPosition;

% Make uPosition 0
result = calllib('libximc','command_move', device_id_X, start_position_X, 0);
result = calllib('libximc','command_wait_for_stop',device_id_X, 10);

result = calllib('libximc','command_move', device_id_Y, start_position_Y, 0);
result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);

%% Show region - to see if there is any part of the sample outside

pause(3)

result = calllib('libximc','command_move', device_id_X, start_position_X+LX, start_uposition_X);
result = calllib('libximc','command_wait_for_stop',device_id_X, 10);

result = calllib('libximc','command_move', device_id_Y, start_position_Y+LY, start_uposition_Y);
result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);

result = calllib('libximc','command_move', device_id_X, start_position_X, start_uposition_X);
result = calllib('libximc','command_wait_for_stop',device_id_X, 10);

result = calllib('libximc','command_move', device_id_Y, start_position_Y, start_uposition_Y);
result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);

%% Region Determination

X = round(linspace(start_position_X, start_position_X + LX, nSplit));
Y = round(linspace(start_position_Y, start_position_Y + LY, nSplit));

for Iter = 1:nIteration
    
    spectrum = wrapper.getSpectrum(0)'; %trash spectrum
    Region = nan(nSplit,nSplit);
    
    for y = 1:nSplit
        
        clc; disp(100*y/length(Y))
        for x = 1:nSplit
            
            result = calllib('libximc','command_move', device_id_X, X(x), start_uposition_X);
            result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
            
            spectrum = wrapper.getSpectrum(0)';
            
            Region(y,x) = mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2))));
        end
        if mod(y,2)==0
            Region(y,:) = flip(Region(y,:));
        end
        X = flip(X);
        
        result = calllib('libximc','command_move', device_id_Y, Y(y), start_uposition_Y);
        result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
        
    end
    
    figure
    imagesc(Region)
    caxis([min(min(Region)) 2500]) 
    axis equal
    axis tight
    h =  imrect();
    clc; disp('To continue press enter:')
    pause;
    % Rectangle position is given as [xmin, ymin, width, height]
    pos_rect = h.getPosition();
    % Round off so the coordinates can be used as indices
    pos_rect = [floor(pos_rect(1))+1, floor(pos_rect(2))+1, ceil(pos_rect(3))-1, ceil(pos_rect(4))-1];
    close
    
    X_min = X(pos_rect(1));
    X_max = X(min(pos_rect(1)+pos_rect(3),nSplit));
    Y_min = Y(pos_rect(2));
    Y_max = Y(min(pos_rect(2)+pos_rect(4),nSplit));
    
    Region_cropped = Region(pos_rect(2):min(pos_rect(2)+pos_rect(4),nSplit), pos_rect(1):min(pos_rect(1)+pos_rect(3),nSplit));
    
    figure
    imagesc(Region_cropped)
    caxis([min(min(Region)) 2500])
    axis equal
    axis tight
    title('Cropped Region')
    clc; disp('To continue press enter:')
    pause;
    close
    
    if Iter == nIteration-1
        nSplit = 2*nSplit;
    end
    
    X = round(linspace(X_min, X_max, nSplit));
    Y = round(linspace(Y_min, Y_max, nSplit));
    
end

clc; fprintf("Starting position: X = %d, Y = %d\n", X_min, Y_min)
fprintf("Number of steps X = %d ; Number of steps Y = %d\n", ceil((X_max-X_min)/StepSize), ceil((Y_max-Y_min)/StepSize))

clear h i Iter pos_rect Region Region_cropped result spectrum x X y Y

%% Fast Preliminary Scanning of The Determined Region

X = X_min: StepSize*2 : X_max;
Y = Y_min: StepSize*2 : Y_max;
spectrum = wrapper.getSpectrum(0)'; %trash spectrum

Map = nan(length(Y),length(X));

for y = 1:length(Y)
    clc; disp(round(100*y/length(Y)))
    for x = 1:length(X)
        
        result = calllib('libximc','command_move', device_id_X, X(x), start_uposition_X);
        result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
        
        spectrum = wrapper.getSpectrum(0)';
        
        Map(y,x) = mean(spectrum(and(wl>=Treshold_region(1), wl<=Treshold_region(2))));
    end
    if mod(y,2)==0
        Map(y,:) = flip(Map(y,:));
    end
    X = flip(X);
    
    result = calllib('libximc','command_move', device_id_Y, Y(y), start_uposition_Y);
    result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
    
end

figure
imagesc(Map)
caxis([min(Map(~isoutlier(Map))) max(Map(~isoutlier(Map)))])
pbaspect([length(X) length(Y) 1])

clear x X y Y spectrum

%% Scanning

[FileName,PathName] = uiputfile('C:\Users\PAM\Desktop\raman measurements');

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
    for x = 1:length(X)
        
        result = calllib('libximc','command_move', device_id_X, X(x), start_uposition_X);
        result = calllib('libximc','command_wait_for_stop',device_id_X, 10);
        
        spectrum = wrapper.getSpectrum(0)';

        log_max = spectrum > max_spec;
        log_min = spectrum < min_spec;
        max_spec(log_max) = spectrum(log_max);
        min_spec(log_min) = spectrum(log_min);
        plot(wl, max_spec, wl, spectrum, wl, min_spec, 'LineWidth', 1.5);
        legend('Max', 'Current', 'Min')
        pause(0.0001)

        RawData(y,x,:) = spectrum;
    end
    if mod(y,2)==0
        RawData(y,:,:) = flip(RawData(y,:,:));
    end
    X = flip(X);
    
    result = calllib('libximc','command_move', device_id_Y, Y(y), start_uposition_Y);
    result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);
    
end

save(fullfile(PathName,[FileName, '.mat']), 'wl', 'RawData', 'StepSize','IntTime')

figure
MeanMap = mean(RawData(:,:,and(wl>=Treshold_region(1), wl<=Treshold_region(2))),3);
imagesc(MeanMap)
caxis([min(MeanMap(~isoutlier(MeanMap))) max(MeanMap(~isoutlier(MeanMap)))])
pbaspect([length(X) length(Y) 1])

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
