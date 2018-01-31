function [MAS] = agentSendReferences(MAS)


%% Local Variables
n = MAS.n;                  % Number of Agents
d = MAS.d;                  % Sampling Time
dt = MAS.dt;
kin = MAS.kin;              % Kinematics [0: Single Integrator; 1: Unicycle; 2: Quadrotor]
rpy = MAS.pose.rpy;
xyz = MAS.pose.xyz;

% For each agent
for i=1:n
    
    if (MAS.GAZEBO)
        
        agent = MAS.agents{i};
        u = agent.u';
        yaw = rpy(i,3);
        
        if (kin == 1)
            % Feedback Linearization for Controlling Unicycle
            
            % Compute control input
            b = 0.12;
            
            iT =  [
                cos(yaw) sin(yaw);
                -1/b*sin(yaw) 1/b*cos(yaw);
                ];
            % Use smoothing gain
            vw= iT*u(1:d);
            % Prepare Message
            agent.control_msg.Linear.X = vw(1);
            agent.control_msg.Linear.Y = 0;
            agent.control_msg.Linear.Z = 0;
            agent.control_msg.Angular.X = 0;
            agent.control_msg.Angular.Y = 0;
            agent.control_msg.Angular.Z = vw(2);
            
        elseif (kin == 2)
            
            yaw = -yaw;
            
            R = [cos(yaw) -sin(yaw)
                sin(yaw) cos(yaw)];
            
            u_xy = u(1:2);
            
            u(1:2)= diag([1 -1])*R*u_xy;
            
            % Prepare the message
            agent.control_msg.Roll = u(2);         % Y
            agent.control_msg.Pitch = u(1);         % X
            agent.control_msg.Thrust.X = 0;
            agent.control_msg.YawRate = u(4);
            agent.control_msg.Thrust.Y = 0;
            agent.control_msg.Thrust.Z = u(3); %15.15
            
        end
        % Save
        MAS.agents{i} = agent;
        
        %% Wait for Integration
        % Send Message
        send(MAS.agents{i}.control_pub,MAS.agents{i}.control_msg);
        
    else
        agent = MAS.agents{i};
        
        linear_vel_ref = MAS.agents{i}.vel_ref.linear;
        
        point_x = xyz(i,1) + dt * linear_vel_ref(1);
        point_y = xyz(i,2) + dt * linear_vel_ref(2);
        point_z = 0.7;
        
        switch (MAS.HW)
            case 'CF'
                agent.control_msg.Header.Stamp = rostime('now');
                agent.control_msg.Header.FrameId = '/world';
                % Prepare Message
                agent.control_msg.Pose.Position.X = point_x;
                agent.control_msg.Pose.Position.Y = point_y;
                agent.control_msg.Pose.Position.Z = point_z;
                agent.control_msg.Pose.Orientation.X = 0;
                agent.control_msg.Pose.Orientation.Y = 0;
                agent.control_msg.Pose.Orientation.Z = 0;
                agent.control_msg.Pose.Orientation.W = 1;
                % Save
                MAS.agents{i} = agent;
                % Send Message
                send(MAS.agents{i}.control_pub,MAS.agents{i}.control_msg);
                
            case 'DJI'
                disp('To be implemented yet')
%                 % Prepare Message
%                 agent.control_msg.Linear.X = MAS.agents{i}.vel_ref.linear(1);
%                 agent.control_msg.Linear.Y = MAS.agents{i}.vel_ref.linear(2);
%                 agent.control_msg.Linear.Z = MAS.agents{i}.vel_ref.linear(3) ;
%                 agent.control_msg.Angular.X = MAS.agents{i}.vel_ref.angular(1);
%                 agent.control_msg.Angular.Y = MAS.agents{i}.vel_ref.angular(2);
%                 agent.control_msg.Angular.Z = MAS.agents{i}.vel_ref.angular(3);
%                 % Save
%                 MAS.agents{i} = agent;
%                 % Send Message
%                 send(MAS.agents{i}.control_pub,MAS.agents{i}.control_msg);
        end
        
    end
end

end
