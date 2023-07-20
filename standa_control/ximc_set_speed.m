function [ ] = ximc_set_speed(device_id, speed, uspeed)

% here is a trick.
% we need to init a struct with any real field from the header.
dummy_struct = struct('Speed',0);
parg_struct = libpointer('move_settings_t', dummy_struct);

% read current engine settings from motor
[result, move_settings] = calllib('libximc','get_move_settings', device_id, parg_struct);

clear parg_struct
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
end

move_settings.Speed = speed;
move_settings.uSpeed = uspeed;

% write engine settings to controller
result= calllib('libximc', 'set_move_settings', device_id, move_settings)
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
end

end