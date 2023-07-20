function [ res_struct ] = ximc_get_status_calb(device_id, calibration)

% here is a trick.
% we need to init a struct with any real field from the header.
dummy_struct = struct('Flags',999);
parg_struct = libpointer('status_calb_t', dummy_struct);
parg2_struct = libpointer('calibration_t', calibration);
[result, res_struct] = calllib('libximc','get_status_calb', device_id, parg_struct, parg2_struct);
clear parg_struct
clear parg2_struct
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
    res_struct = 0;
end

end

