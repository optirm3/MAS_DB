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
            if MAS.agents{i}.type == 1
                landRequest(MAS.agents{i});
            else
                agent = MAS.agents{i};
                agent.control_msg.Linear.X = 0;
                agent.control_msg.Linear.Y = 0;
                agent.control_msg.Linear.Z = 0;
                agent.control_msg.Angular.X = 0;
                agent.control_msg.Angular.Y = 0;
                agent.control_msg.Angular.Z = 0;
                send(agent.control_pub,agent.control_msg);
            end
        end
        
    end
end

pause(0.1)

end
