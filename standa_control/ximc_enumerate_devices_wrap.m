function [ names_array ] = ximc_enumerate_devices_wrap(probe_devices, hints)
    dev_enum = calllib('libximc', 'enumerate_devices', probe_devices, hints);
    names_count = calllib('libximc','get_device_count', dev_enum);
    names_array = cell(1,names_count);
    for i=1:names_count
        names_array{1,i} = calllib('libximc','get_device_name', dev_enum, i-1);
    end
    calllib('libximc','free_enumerate_devices', dev_enum);
end
