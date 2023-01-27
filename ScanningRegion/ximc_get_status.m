function [ res_struct ] = ximc_get_status(device_id)

% here is a trick.
% we need to init a struct with any real field from the header.
dummy_struct = struct('Flags',999);
parg_struct = libpointer('status_t', dummy_struct);
[result, res_struct] = calllib('libximc','get_status', device_id, parg_struct);
clear parg_struct
if result ~= 0
    disp(['Command failed with code', num2str(result)]);
    res_struct = 0;
end

end

