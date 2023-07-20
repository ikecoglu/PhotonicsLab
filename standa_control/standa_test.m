% MATLAB test for XIMC library
% Tested R2014b 32-bit WinXP, R2014b 64-bit Win7, R2014b 64-bit OSX 10.10
clc
clear
%onemli bilgi: bir step 2.5um.
height=400;%taranacak alanin bir kenarinin gercek step uzunlugu.  **************** ONEMLI PARAMETRE BULMASI KOLAY OLSUN **************
our_step=2;%bizim bir stepimizin gercekte kac step oldugu. **************** ONEMLI PARAMETRE BULMASI KOLAY OLSUN **************


x=our_step;
j=0;

speed=1000;
uspeed=1000;
%% Spectrometer
wrapper = com.oceanoptics.omnidriver.api.wrapper.Wrapper(); %wrapper class?n? objeye dönüstürür.
wrapper.openAllSpectrometers();
wrapper.getName(0)
wl = wrapper.getWavelengths(0); %plot ederken y ekseninin buyuklugunu bulabilmek icin lazim.
wrapper.setScansToAverage(0,2);
t = 2e6; %integration time buraya girilir.   **************** ONEMLI PARAMETRE BULMASI KOLAY OLSUN **************
wrapper.setIntegrationTime(0,t);
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
%%
start_position1 = state_s1.CurPosition;
start_uposition1 = state_s1.uCurPosition;
start_position2 = state_s2.CurPosition;
start_uposition2 = state_s2.uCurPosition;

% disp(['Current position ', num2str(start_position1), ' steps, ', num2str(start_uposition1), ' microsteps'])
% disp(['Current position ', num2str(start_position2), ' steps, ', num2str(start_uposition2), ' microsteps'])

stoploop=false;
tolerance=400;

pos_y=0;
pos_x=0;
spectrum= wrapper.getSpectrum(0);%trash spectrum
wrapper.getCorrectForElectricalDark(0);
wrapper.getCorrectForDetectorNonlinearity(0);
wrapper.setBoxcarWidth(0,1);

[FileName,PathName] = uiputfile('*');
counter=0;
step = our_step;
spectrum = wrapper.getSpectrum(0);
wl = wrapper.getWavelengths(0);
spec = [wl, spectrum];
filename = strcat(FileName,num2str(1));                                           
dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
while (counter<(height/our_step+1)) & (stoploop==false)
    b = mod(j,4);
    
        if b==0
            for i=counter*(height/our_step+1)+2:(height/our_step+1)*(counter+1)
                result2 = calllib('libximc','command_move', device_id2, start_position2+step, start_uposition2);
                result2 = calllib('libximc','command_wait_for_stop',device_id2, 10);
                spectrum = wrapper.getSpectrum(0);
                wl = wrapper.getWavelengths(0);
                spec = [wl, spectrum];
                filename = strcat(FileName,num2str(i));                                           
                dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
                step=step+our_step;
            end
            step=our_step;
            counter=counter+1;
%             while pos_y<start_position2+height-tolerance
%                 state_s2 = ximc_get_status(device_id2);
%                 pos_y=state_s2.CurPosition;
%             end
            j=j+1;

                       
        elseif b==2
            for i=counter*(height/our_step+1)+2:(height/our_step+1)*(counter+1)
                result2 = calllib('libximc','command_move', device_id2,start_position2+ height-our_step-step, start_uposition2);
                result2 = calllib('libximc','command_wait_for_stop', device_id2, 10);
                spectrum = wrapper.getSpectrum(0);
                wl = wrapper.getWavelengths(0);
                spec = [wl, spectrum];
                filename = strcat(FileName,num2str(i));                                           %
                dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
                step=step + our_step;
            end
            step=our_step;
            counter=counter+1;
%             while pos_y>start_position2+tolerance
%                 state_s2 = ximc_get_status(device_id2);
%                 pos_y=state_s2.CurPosition;
%             end
            j=j+1;
            
            
            
        elseif and(b==1 || b==3, counter<(height/our_step+1))
            result1 = calllib('libximc','command_move', device_id1, start_position1+x, start_uposition1);
            result1 = calllib('libximc','command_wait_for_stop', device_id1, 10);
            spectrum = wrapper.getSpectrum(0);
            wl = wrapper.getWavelengths(0);
            spec = [wl, spectrum];
            filename = strcat(FileName,num2str(counter*(height/our_step+1)+1));                                           %
            dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
%             while pos_x<start_position1-spacing/2+x
%                 state_s1 = ximc_get_status(device_id1);
%                 pos_x=state_s1.CurPosition;
%             end
            j=j+1;
            x=x+our_step;
           
        end
    %j=j+1;
end
%%
result2 = calllib('libximc','command_move', device_id2, start_position2, start_uposition2);
result1 = calllib('libximc','command_move', device_id1, start_position1, start_uposition1);

 state_s1 = ximc_get_status(device_id1);
% disp('Status:'); disp(state_s1);

 state_s2 = ximc_get_status(device_id2);
 
% disp('Status:'); disp(state_s2);

device_id_ptr1 = libpointer('int32Ptr', device_id1);
device_id_ptr2 = libpointer('int32Ptr', device_id2);
calllib('libximc','close_device', device_id_ptr1);
calllib('libximc','close_device', device_id_ptr2);
wrapper.closeAllSpectrometers();
disp('Done');
% when needed
% unloadlibrary('libximc');
