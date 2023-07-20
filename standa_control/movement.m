height=500;
width=500;
spacing=100;
x=0;
j=0;

while x<width
    b = mod(j,4)
    
        if b==0
            result2 = calllib('libximc','command_move', device_id2, start_position2+height, start_uposition2);
            if result2 ~= 0
                disp(['Command failed with code', num2str(result2)]);
            end
            result2 = calllib('libximc','command_wait_for_stop', device_id2, 10);
            if result2 ~= 0
                disp(['Command failed with code', num2str(result2)]);
            end
        elseif b==2
            result2 = calllib('libximc','command_move', device_id2, start_position2, start_uposition2);
            if result2 ~= 0
                disp(['Command failed with code', num2str(result2)]);
            end
            result2 = calllib('libximc','command_wait_for_stop', device_id2, 10);
            if result2 ~= 0
                disp(['Command failed with code', num2str(result2)]);
            end
        elseif b==1 || b==3
            result1 = calllib('libximc','command_move', device_id1, start_position1+x, start_uposition1);
            if result1 ~= 0
                disp(['Command failed with code', num2str(result1)]);
            end
            result1 = calllib('libximc','command_wait_for_stop', device_id1, 10);
            if result1 ~= 0
                disp(['Command failed with code', num2str(result1)]);
            end
        end
        
    x=x+spacing;
    j=j+1;
end