function []=stopRobots(MAS)

n=MAS.n;

for i=1:n
    if (MAS.kin == 1)
        
        MAS.agents{i}.control_msg.Linear.X = 0;
        MAS.agents{i}.control_msg.Angular.Z = 0;
        send(MAS.agents{i}.control_pub,MAS.agents{i}.control_msg);
        
    elseif (MAS.kin == 2)
        
        if MAS.GAZEBO
            MAS.agents{i}.control_msg.Roll = 0;
            MAS.agents{i}.control_msg.Pitch = 0;
            MAS.agents{i}.control_msg.Thrust.Z = 0;
            send(MAS.agents{i}.control_pub,MAS.agents{i}.control_msg);
        else
            landRequest(MAS.agents{i});
        end
        
    end
end

pause(0.1)

end
