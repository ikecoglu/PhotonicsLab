function [ speed, uspeed ] = ximc_get_speed(device_id)

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

speed = move_settings.Speed;
uspeed = move_settings.uSpeed;

end