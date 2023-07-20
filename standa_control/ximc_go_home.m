function [ ] = ximc_go_home(device_id)

disp('Homing...')
result = calllib('libximc', 'command_home', device_id);
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
end
disp('Waiting for stop...');
result = calllib('libximc','command_wait_for_stop', device_id, 100);
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
end

end