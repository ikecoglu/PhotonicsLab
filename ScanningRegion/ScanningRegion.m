clear; close all; clc;
%% Parameters
% 1 step = 256 ustep | 1 step = 2.5 um

LX = 2000; % Max value of X length in steps, for the initial scan
LY = 2000; % Max value of Y length in steps, for the initial scan
nIteration = 3; % Number of times the regions is being shrunk

StepSize = 20; % Step size to use after determining the region. In steps.

IntTime = 1e5; % integration time in terms of microsecond
num_of_average = 0; %number of spectrums to take average of in each location, no average = 0

% Not recommended to change
speed = 1000;
uspeed = 1000;

%% Spectrometer

wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper();
wrapper.openAllSpectrometers();
wrapper.getName(0)
wl = wrapper.getWavelengths(0);
if num_of_average > 0
    wrapper.setScansToAverage(0,num_of_average);
end
wrapper.setIntegrationTime(0,IntTime);
wrapper.getCorrectForElectricalDark(0);
wrapper.getCorrectForDetectorNonlinearity(0);
wrapper.setBoxcarWidth(0,1);

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
        addpath(fullfile(pwd,'../../ximc/win64/wrappers/matlab/'));
        if (is64bit)
            addpath(fullfile(pwd,'../../ximc/win64/'));
            [notfound,warnings] = loadlibrary('libximc.dll', @ximcm)
        else
            addpath(fullfile(pwd,'../../ximc/win32/'));
            [notfound, warnings] = loadlibrary('libximc.dll', 'ximcm.h', 'addheader', 'ximc.h')
        end
    elseif ismac
        addpath(fullfile(pwd,'../../ximc/'));
        [notfound, warnings] = loadlibrary('libximc.framework/libximc', 'ximcm.h', 'mfilename', 'ximcm.m', 'includepath', 'libximc.framework/Versions/Current/Headers', 'addheader', 'ximc.h')
    elseif isunix
        [notfound, warnings] = loadlibrary('libximc.so', 'ximcm.h', 'addheader', 'ximc.h')
    end
end

% Set bindy (network) keyfile. Must be called before any call to "enumerate_devices" or "open_device" if you
% wish to use network-attached controllers. Accepts both absolute and relative paths, relative paths are resolved
% relative to the process working directory. If you do not need network devices then "set_bindy_key" is optional.
calllib('libximc','set_bindy_key', '../../ximc/win32/keyfile.sqlite')

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

start_position_Y = state_Y.CurPosition;
start_uposition_Y = state_Y.uCurPosition;
start_position_X = state_X.CurPosition;
start_uposition_X = state_X.uCurPosition;

% Make uPosition 0

result = calllib('libximc','command_move', device_id_X, start_position_X, 0);
result = calllib('libximc','command_wait_for_stop',device_id_X, 10);

result = calllib('libximc','command_move', device_id_Y, start_position_Y, 0);
result = calllib('libximc','command_wait_for_stop',device_id_Y, 10);

%% Scanning

spectrum = wrapper.getSpectrum(0); %trash spectrum

X = round(linspace(start_position_X, start_position_X + LX, 10));
Y = round(linspace(start_position_Y, start_position_Y + LY, 10));

for Iter = 1:nIteration

    for y = 1:10

        for x = 1:10

            result = calllib('libximc','command_move', device_id_X, X(x), start_uposition_X);
            result = calllib('libximc','command_wait_for_stop',device_id_X, 10);

            spectrum = wrapper.getSpectrum(0);
            wl = wrapper.getWavelengths(0);
        end
        if mod(y,2)==0
            spectrum = flip(spectrum,1);
        end
%         Region(y,:) = and(spectrum>=4, spectrum<7)';
        X = flip(X);

    end

    X_margin = sum(Region,1)==0;
    Y_margin = sum(Region,2)==0;

    X_min = X(find(X_margin==0, 1, 'first')-1);
    X_max = X(find(X_margin==0, 1, 'last')+1);

    Y_min = Y(find(Y_margin==0, 1, 'first')-1);
    Y_max = Y(find(Y_margin==0, 1, 'last')+1);

    X = round(linspace(X_min, X_max, 10));
    Y = round(linspace(Y_min, Y_max, 10));

end

disp(strcat("Starting position: X = %d, Y = %d", X_min, Y_min))
disp(strcat("Number of steps X = %d ; Number of steps Y = %d", ceil((X_max-X_min)/StepSize), ceil((Y_max-Y_min)/StepSize)))
%% Closing protocol

% Go to (X_min, Y_min)
result = calllib('libximc','command_move', device_id_X, X_min, start_uposition_X);
result = calllib('libximc','command_move', device_id_Y, Y_min, start_uposition_Y);

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
