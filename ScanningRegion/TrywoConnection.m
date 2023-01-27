clear; clc;
%% Parameters
% 1 step = 256 ustep | 1 step = 2.5 um

StepSize = 64; %in terms of microsteps
num_of_step_A=20; % num of steps in side A
num_of_step_B=40; % num of steps in side B

% don't touch this part
step = (StepSize - mod(StepSize, 256) ) / 256;
ustep = mod(StepSize, 256);
%% Scanning

count = 1;
[FileName,PathName] = uiputfile('*');
spectrum = [1 2 3 4 5];
wl = [10 20 30 40 50];
spec = [wl, spectrum];
filename = strcat(FileName,num2str(count));
dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
count = count+1;


cur_position1 = 0;
cur_uposition1 = 0;
cur_position2 = 0;
cur_uposition2 = 0;
m1l = [];
m2l = [];

direct = true;
for k = 1:num_of_step_B + 1
    if direct
        for l = 1:num_of_step_A
            
            next_pos2 = cur_position2 + step;
            next_upos2 = cur_uposition2 + ustep;
            if next_upos2 >= 256
                next_upos2 = mod(next_upos2, 256);
                next_pos2 = next_pos2 + 1;
            end
            cur_position2 = next_pos2;
            cur_uposition2 = next_upos2;
            m2l = [m2l; [cur_position2 cur_uposition2]];
            
            spectrum = [1 2 3 4 5];
            wl = [10 20 30 40 50];
            spec = [wl, spectrum];
            filename = strcat(FileName,num2str(count));
            dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
            count = count + 1;
        end
        direct = false;
    else
        for l = 1:num_of_step_A
            
            next_pos2 = cur_position2 - step;
            next_upos2 = cur_uposition2 - ustep;
            if next_upos2 < 0
                next_upos2 = next_upos2 + 256;
                next_pos2 = next_pos2 - 1;
            end
            cur_position2 = next_pos2;
            cur_uposition2 = next_upos2;
            m2l = [m2l; [cur_position2 cur_uposition2]];
            
            spectrum = [1 2 3 4 5];
            wl = [10 20 30 40 50];
            spec = [wl, spectrum];
            filename = strcat(FileName,num2str(count));
            dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
            count = count + 1;
        end
        direct = true;
    end
    if k ~= num_of_step_B + 1
        
        next_pos1 = cur_position1 + step;
        next_upos1 = cur_uposition1 + ustep;
        if next_upos1 >= 256
            next_upos1 = mod(next_upos1, 256);
            next_pos1 = next_pos1 + 1;
        end
        cur_position1 = next_pos1;
        cur_uposition1 = next_upos1;
        m1l = [m1l; [cur_position1 cur_uposition1]];
        
        spectrum = [1 2 3 4 5];
        wl = [10 20 30 40 50];
        spec = [wl, spectrum];
        filename = strcat(FileName,num2str(count));
        dlmwrite(fullfile(PathName,filename),spec,'delimiter',',');
        count = count + 1;
    end
end
disp("Done!")