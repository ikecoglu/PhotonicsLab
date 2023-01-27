function varargout = standa_gui(varargin)
% STANDA_GUI MATLAB code for standa_gui.fig
%      STANDA_GUI, by itself, creates a new STANDA_GUI or raises the existing
%      singleton*.
%
%      H = STANDA_GUI returns the handle to a new STANDA_GUI or the handle to
%      the existing singleton*.
%
%      STANDA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STANDA_GUI.M with the given input arguments.
%
%      STANDA_GUI('Property','Value',...) creates a new STANDA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before standa_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to standa_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help standa_gui

% Last Modified by GUIDE v2.5 02-Sep-2019 10:32:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @standa_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @standa_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before standa_gui is made visible.
function standa_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to standa_gui (see VARARGIN)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes standa_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = standa_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    handles.width_n = str2double(get(hObject,'String'));


guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    handles.height_n = str2double(get(hObject,'String'));


guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.spacing_n = str2double(get(hObject,'String'));


guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dev_1=handles.device_id1;
dev_2=handles.device_id2;

ximc_go_home(handles.device_id1);
ximc_go_home(handles.device_id2);

state_s1 = ximc_get_status(dev_1);
state_s2 = ximc_get_status(dev_2);

handles.Home_position1 = state_s1.CurPosition;
handles.Home_uposition1 = state_s1.uCurPosition;
handles.Home_position2 = state_s2.CurPosition;
handles.Home_uposition2 = state_s2.uCurPosition;
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dev_1=handles.device_id1;
dev_2=handles.device_id2;
global stoploop
stoploop=false;
height=handles.height_n;
width=handles.width_n;
spacing=handles.spacing_n;
x=spacing;
j=0;

state_s1 = ximc_get_status(dev_1);
% disp('Status:'); disp(state_s1);
state_s2 = ximc_get_status(dev_2);
% disp('Status:'); disp(state_s2);

start_position1 = state_s1.CurPosition;
start_uposition1 = state_s1.uCurPosition;
start_position2 = state_s2.CurPosition;
start_uposition2 = state_s2.uCurPosition;

pos_x=start_position1;
pos_y=start_position2;

% disp(['Current position ', num2str(start_position1), ' steps, ', num2str(start_uposition1), ' microsteps'])
% disp(['Current position ', num2str(start_position2), ' steps, ', num2str(start_uposition2), ' microsteps'])

tolerance=50;

if(handles.raster_scan==1)
    while (x<width) & (stoploop==false)
        b = mod(j,4); 
            if b==0

                result2 = calllib('libximc','command_move', dev_2, start_position2+height, start_uposition2);
                while pos_y<start_position2+height-tolerance
                    state_s2 = ximc_get_status(dev_2);
                    pos_y=state_s2.CurPosition;
                end
                j=j+1;

                %result2 = calllib('libximc','command_wait_for_stop', dev_2, 10);

            elseif b==2
                result2 = calllib('libximc','command_move', dev_2, start_position2, start_uposition2);
                while pos_y>start_position2+tolerance
                    state_s2 = ximc_get_status(dev_2);
                    pos_y=state_s2.CurPosition;
                end
                j=j+1;

                %result2 = calllib('libximc','command_wait_for_stop', dev_2, 10);

            elseif b==1 || b==3
                result1 = calllib('libximc','command_move', dev_1, start_position1+x, start_uposition1);
                
                while pos_x<start_position1-spacing/2+x
                    state_s1 = ximc_get_status(dev_1);
                    pos_x=state_s1.CurPosition;
                end
                
                j=j+1;
                %result1 = calllib('libximc','command_wait_for_stop', dev_1, 10);
                x=x+spacing;

            end
        %j=j+1;
    end
elseif(handles.raster_scan==2)
 
    result2 = calllib('libximc','command_move', dev_2, start_position2+height, start_uposition2);
        while pos_y<start_position2+height-tolerance
            state_s2 = ximc_get_status(dev_2);
            pos_y=state_s2.CurPosition;
        end
    result1 = calllib('libximc','command_move', dev_1, start_position1+width, start_uposition1);
        while pos_x<start_position1+width-tolerance
            state_s1 = ximc_get_status(dev_1);
            pos_x=state_s1.CurPosition;

        end
    result2 = calllib('libximc','command_move', dev_2, start_position2, start_uposition2);
        while pos_y>start_position2+tolerance
            state_s2 = ximc_get_status(dev_2);
            pos_y=state_s2.CurPosition;
        end
    result1 = calllib('libximc','command_move', dev_1, start_position1, start_uposition1);
        while pos_x>start_position1+tolerance
            state_s1 = ximc_get_status(dev_1);
            pos_x=state_s1.CurPosition;

        end
        
    result1 = calllib('libximc','command_wait_for_stop', dev_1, 10);
    result2 = calllib('libximc','command_wait_for_stop', dev_2, 10);
 
end

% state_s1 = ximc_get_status(dev_1);
% disp('Status:'); disp(state_s1);
% state_s2 = ximc_get_status(dev_2);
% disp('Status:'); disp(state_s2);

disp('Done');
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display(handles.raster_scan)
global stoploop
stoploop=true;



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    handles.speed_n = str2double(get(hObject,'String'));



guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dev_1=handles.device_id1;
dev_2=handles.device_id2;
dev_s=handles.speed_n;

ximc_set_speed(dev_1, dev_s , dev_s);
ximc_set_speed(dev_2, dev_s, dev_s);


guidata(hObject, handles);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    handles.X_abs_p = str2double(get(hObject,'String'));


guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    handles.Y_abs_p = str2double(get(hObject,'String'));


guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dev_1=handles.device_id1;
dev_2=handles.device_id2;



H_p1 = handles.Home_position1+handles.X_abs_p;
H_up1 = handles.Home_uposition1;
H_p2 = handles.Home_position2+handles.Y_abs_p;
H_up2 = handles.Home_uposition2;

    result1 = calllib('libximc','command_move', dev_1, H_p1, H_up1);
    result2 = calllib('libximc','command_move', dev_2, H_p2, H_up2);
    result1 = calllib('libximc','command_wait_for_stop', dev_1, 10);
    result2 = calllib('libximc','command_wait_for_stop', dev_2, 10);
guidata(hObject, handles);
            



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.raster_scan=1; %initializing the scan type

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
disp(['Using device name ', device_name1]);
device_name2 = device_names{1,2};
disp(['Using device name ', device_name2]);

device_id1 = calllib('libximc','open_device', device_name1);
disp(['Using device id ', num2str(device_id1)]);
device_id2 = calllib('libximc','open_device', device_name2);
disp(['Using device id ', num2str(device_id2)]);

calb = struct();
calb.A = 0.1; % arbitrary choice for example, set by user in real scenarios
calb.MicrostepMode = 4; % == MICROSTEP_MODE_FRAC_8
state_calb_s1 = ximc_get_status_calb(device_id1, calb);
state_calb_s2 = ximc_get_status_calb(device_id2, calb);
disp('Status calb:'); disp(state_calb_s1);
disp('Status calb:'); disp(state_calb_s2);

disp('Set microstep mode to 256...');
ximc_set_microstep_256(device_id1);
ximc_set_microstep_256(device_id2);



disp('Change speed...')

speed=1000;
uspeed=1000;

ximc_set_speed(device_id1, speed , uspeed);
ximc_set_speed(device_id2, speed , uspeed);
% Choose default command line output for standa_gui
handles.output = hObject;
handles.device_id1=device_id1;
handles.device_id2=device_id2;

handles.speed_n=1000;
handles.width_n=500;
handles.height_n=1000;
handles.spacing_n=50;
handles.X_abs_p=0;
handles.Y_abs_p=0;
handles.X_rel_p=0;
handles.Y_rel_p=0;

guidata(hObject, handles);



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.X_rel_p = str2double(get(hObject,'String'));


guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.Y_rel_p = str2double(get(hObject,'String'));


guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dev_1=handles.device_id1;
dev_2=handles.device_id2;

state_s1 = ximc_get_status(dev_1);
state_s2 = ximc_get_status(dev_2);


start_position1 = state_s1.CurPosition;
start_uposition1 = state_s1.uCurPosition;
start_position2 = state_s2.CurPosition;
start_uposition2 = state_s2.uCurPosition;

H_p1 = start_position1+handles.X_rel_p;
H_up1 = start_uposition1;
H_p2 = start_position2+handles.Y_rel_p;
H_up2 = start_uposition2;

    result1 = calllib('libximc','command_move', dev_1, H_p1, H_up1);
    result2 = calllib('libximc','command_move', dev_2, H_p2, H_up2);
    result1 = calllib('libximc','command_wait_for_stop', dev_1, 10);
    result2 = calllib('libximc','command_wait_for_stop', dev_2, 10);
guidata(hObject, handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(sprintf('https://youtu.be/6xsDdIByh8A\nMr.Fahrenheit '), 'GUI Info','help','modal')


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 sels    = get(hObject,'String');  % get the list of options
 idx     = get(hObject,'Value');   % get the index of the selected option
 handles.raster_scan=idx;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
