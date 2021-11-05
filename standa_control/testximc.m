% MATLAB test for XIMC library
% Tested R2014b 32-bit WinXP, R2014b 64-bit Win7, R2014b 64-bit OSX 10.10
clc
clear

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
device_name = device_names{1,1};
disp(['Using device name ', device_name]);

device_id = calllib('libximc','open_device', device_name);
disp(['Using device id ', num2str(device_id)]);

disp('Set microstep mode to 256...');
ximc_set_microstep_256(device_id);

state_s = ximc_get_status(device_id);
disp('Status:'); disp(state_s);

start_position = state_s.CurPosition;
start_uposition = state_s.uCurPosition;

disp(['Current position ', num2str(start_position), ' steps, ', num2str(start_uposition), ' microsteps'])

disp('Running engine to the right for 5 seconds...');
result = calllib('libximc','command_right', device_id);
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
end

pause(5);

calb = struct();
calb.A = 0.1; % arbitrary choice for example, set by user in real scenarios
calb.MicrostepMode = 9; % == MICROSTEP_MODE_FRAC_256
state_calb_s = ximc_get_status_calb(device_id, calb);
disp('Status calb:'); disp(state_calb_s);

state_s = ximc_get_status(device_id);
disp('Status:'); disp(state_s);

disp('Change speed...')
[speed, uspeed] = ximc_get_speed(device_id);
ximc_set_speed(device_id, speed / 2, uspeed);

disp('Move back ...')
result = calllib('libximc','command_move', device_id, start_position, start_uposition);
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
end

disp('Waiting for stop...');
result = calllib('libximc','command_wait_for_stop', device_id, 100);
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
end

state_s = ximc_get_status(device_id);
disp('Status:'); disp(state_s);

device_id_ptr = libpointer('int32Ptr', device_id);
calllib('libximc','close_device', device_id_ptr);
disp('Done');
% when needed
% unloadlibrary('libximc');
