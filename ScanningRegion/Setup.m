function [ret] = Setup(handle)
% Set the acquisition, channel and trigger parameters for the system and
% calls ConfigureAcquisition, ConfigureChannel and ConfigureTrigger.

[ret, sysinfo] = CsMl_GetSystemInfo(handle);
CsMl_ErrorHandler(ret, 1, handle);

acqInfo.SampleRate = 200e6; %200e6;
acqInfo.ExtClock = 0;
acqInfo.Mode = CsMl_Translate('Dual', 'Mode');
acqInfo.SegmentCount = 2^9;
acqInfo.Depth = 3040;%3040
acqInfo.SegmentSize = 3040;%3040
acqInfo.TriggerTimeout = 2000;%2000
acqInfo.TriggerHoldoff = 0;
acqInfo.TriggerDelay = 0;
acqInfo.TimeStampConfig = 0;

[ret] = CsMl_ConfigureAcquisition(handle, acqInfo);
CsMl_ErrorHandler(ret, 1, handle);

% Set up all the channels even though
% they might not all be used. For example
% in a 2 board master / slave system, in single channel
% mode only channels 1 and 3 are used.
for i = 1:sysinfo.ChannelCount
    chan(i).Channel = i;
    chan(i).Coupling = CsMl_Translate('DC', 'Coupling');
    chan(i).DiffInput = 0;
    chan(i).InputRange = 2000;%2000
    chan(i).Impedance = 50;
    chan(i).DcOffset = 0;
    chan(i).DirectAdc = 0;
    chan(i).Filter = 0; 
end;   

[ret] = CsMl_ConfigureChannel(handle, chan);
CsMl_ErrorHandler(ret, 1, handle);

trig.Trigger = 1;
trig.Slope = CsMl_Translate('Positive', 'Slope');
trig.Level = 50;
trig.Source = 1;
trig.ExtCoupling = CsMl_Translate('DC', 'ExtCoupling');
trig.ExtRange = 2000;

[ret] = CsMl_ConfigureTrigger(handle, trig);
CsMl_ErrorHandler(ret, 1, handle);

ret = 1;
