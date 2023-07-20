clear; close all; clc;
%% Parameters
% 1 step = 256 ustep | 1 step = 2.5 um

StepSize = 256*10; %in terms of microsteps
num_of_step_A=20; % num of steps in side A
num_of_step_B=40; % num of steps in side B
IntTime = 1e5; % integration time in terms of microsecond
num_of_average = 0;%number of spectrums to take average of in each location, no average = 0

% don't touch this part
step = (StepSize - mod(StepSize, 256) ) / 256;
ustep = mod(StepSize, 256);
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

device_name1 = device_names{1,1};
% disp(['Using device name ', device_name1]);
device_name2 = device_names{1,2};
% disp(['Using device name ', device_name2]);

device_id1 = calllib('libximc','open_device', device_name1);
% disp(['Using device id ', num2str(device_id1)]);
device_id2 = calllib('libximc','open_device', device_name2);
% disp(['Using device id ', num2str(device_id2)]);

calb = struct();
calb.A = 0.1; % arbitrary choice for example, set by user in real scenarios
calb.MicrostepMode = 4; % == MICROSTEP_MODE_FRAC_8
state_calb_s1 = ximc_get_status_calb(device_id1, calb);
state_calb_s2 = ximc_get_status_calb(device_id2, calb);
% disp('Status calb:'); disp(state_calb_s1);
% disp('Status calb:'); disp(state_calb_s2);

% disp('Set microstep mode to 256...');
ximc_set_microstep_256(device_id1);
ximc_set_microstep_256(device_id2);

% disp('Change speed...')

ximc_set_speed(device_id1, speed , uspeed);
ximc_set_speed(device_id2, speed , uspeed);

state_s1 = ximc_get_status(device_id1);
% disp('Status:'); disp(state_s1);
state_s2 = ximc_get_status(device_id2);
% disp('Status:'); disp(state_s2);

start_position1 = state_s1.CurPosition;
start_uposition1 = state_s1.uCurPosition;
start_position2 = state_s2.CurPosition;
start_uposition2 = state_s2.uCurPosition;
%% Scanning

spectrum= wrapper.getSpectrum(0);%trash spectrum
max_spec = zeros(length(spectrum), 1);
min_spec = repmat(50000, length(spectrum), 1);

count = 1;
[FileName,PathName] = uiputfile('*');
spectrum = wrapper.getSpectrum(0);
wl = wrapper.getWavelengths(0);
spec = [wl, spectrum];
filename = strcat(FileName,num2str(count));
dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
count = count+1;

direct = true;
for k = 1:num_of_step_B + 1
    if direct
        for l = 1:num_of_step_A
            
            state_s2 = ximc_get_status(device_id2);
            cur_position2 = state_s2.CurPosition;
            cur_uposition2 = state_s2.uCurPosition;
            next_pos2 = cur_position2 + step;
            next_upos2 = cur_uposition2 + ustep;
            if next_upos2 >= 256
                next_upos2 = mod(next_upos2, 256);
                next_pos2 = next_pos2 + 1;
            end
            result2 = calllib('libximc','command_move', device_id2, next_pos2, next_upos2);
            result2 = calllib('libximc','command_wait_for_stop',device_id2, 10);
            
            spectrum = wrapper.getSpectrum(0);
            wl = wrapper.getWavelengths(0);
            
            log_max = spectrum > max_spec;
            log_min = spectrum < min_spec;
            max_spec(log_max) = spectrum(log_max);
            min_spec(log_min) = spectrum(log_min);
            plot(wl, max_spec, wl, spectrum, wl, min_spec, 'LineWidth', 1.5);
            legend('Max', 'Current', 'Min')
            pause(0.0001)
            
            spec = [wl, spectrum];
            filename = strcat(FileName,num2str(count));
            dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
            count = count + 1;
        end
        direct = false;
    else
        for l = 1:num_of_step_A
            
            state_s2 = ximc_get_status(device_id2);
            cur_position2 = state_s2.CurPosition;
            cur_uposition2 = state_s2.uCurPosition;
            next_pos2 = cur_position2 - step;
            next_upos2 = cur_uposition2 - ustep;
            if next_upos2 < 0
                next_upos2 = next_upos2 + 256;
                next_pos2 = next_pos2 - 1;
            end
            result2 = calllib('libximc','command_move', device_id2, next_pos2, next_upos2);
            result2 = calllib('libximc','command_wait_for_stop',device_id2, 10);
            
            spectrum = wrapper.getSpectrum(0);
            wl = wrapper.getWavelengths(0);
            
            log_max = spectrum > max_spec;
            log_min = spectrum < min_spec;
            max_spec(log_max) = spectrum(log_max);
            min_spec(log_min) = spectrum(log_min);
            plot(wl, max_spec, wl, spectrum, wl, min_spec, 'LineWidth', 1.5);
            legend('Max', 'Current', 'Min')
            pause(0.0001)
            
            spec = [wl, spectrum];
            filename = strcat(FileName,num2str(count));
            dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
            count = count + 1;
        end
        direct = true;
    end
    if k ~= num_of_step_B + 1
        state_s1 = ximc_get_status(device_id1);
        cur_position1 = state_s1.CurPosition;
        cur_uposition1 = state_s1.uCurPosition;
        next_pos1 = cur_position1 + step;
        next_upos1 = cur_uposition1 + ustep;
        if next_upos1 >= 256
            next_upos1 = mod(next_upos1, 256);
            next_pos1 = next_pos1 + 1;
        end
        result1 = calllib('libximc','command_move', device_id1, next_pos1, next_upos1);
        result1 = calllib('libximc','command_wait_for_stop', device_id1, 10);
        
        spectrum = wrapper.getSpectrum(0);
        wl = wrapper.getWavelengths(0);
        
        log_max = spectrum > max_spec;
        log_min = spectrum < min_spec;
        max_spec(log_max) = spectrum(log_max);
        min_spec(log_min) = spectrum(log_min);
        plot(wl, max_spec, wl, spectrum, wl, min_spec, 'LineWidth', 1.5);
        legend('Max', 'Current', 'Min')
        pause(0.0001)
        
        spec = [wl, spectrum];
        filename = strcat(FileName,num2str(count));
        dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
        count = count + 1;
    end
end
%% Closing protocol

% Return to home
result2 = calllib('libximc','command_move', device_id2, start_position2, start_uposition2);
result1 = calllib('libximc','command_move', device_id1, start_position1, start_uposition1);

% Close stage
device_id_ptr1 = libpointer('int32Ptr', device_id1);
device_id_ptr2 = libpointer('int32Ptr', device_id2);
calllib('libximc','close_device', device_id_ptr1);
calllib('libximc','close_device', device_id_ptr2);

% Close spectrometer
wrapper.closeAllSpectrometers();

disp('Done');

% when needed
% unloadlibrary('libximc');
