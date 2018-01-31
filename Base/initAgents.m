% Initialize the  ROS data structure for the robots
function MAS = initAgents(MAS)

n = MAS.n;
robot_name = MAS.robot_name;
RobCFs = MAS.RobCFs;
n_CF = length(RobCFs);
RobSAs = MAS.RobSAs;

for i=1:n
    %% Connect To the Agent
    agent.id = i;
    agent.rho0 = MAS.rho0;
    agent.rho = MAS.rho;
    agent.u = zeros(MAS.d,1);
    agent.u_opt = zeros(MAS.d,1);
    agent.vel_ref.linear = zeros(1,3);
    agent.vel_ref.angular = zeros(1,3);
    agent.nbrs = [];
    
    % GROUND
    if (MAS.kin == 1)
        
        agent.pose_sub = rossubscriber(sprintf('/robot_%d/odom',i));
        agent.control_pub = rospublisher(sprintf('/robot_%d/cmd_vel',i));
        agent.control_msg = rosmessage(agent.vel);
        
        % AIR
    elseif (MAS.kin == 2)
        
        if (MAS.GAZEBO)
            % Subscribe Robot Control
            if (topicRegistered(sprintf('/%s_%d/command/roll_pitch_yawrate_thrust',robot_name,i)))
                agent.control_pub = rospublisher(sprintf('/%s_%d/command/roll_pitch_yawrate_thrust',robot_name,i));
                % Create Command
                agent.control_msg = rosmessage(agent.control_pub);
            else
                error('cannot create control publisher');
            end
            
            % Subscribe Robot Pose
            if (topicRegistered(sprintf('/%s_%d/ground_truth/pose',robot_name,i)))
                agent.pose_sub = rossubscriber(sprintf('/%s_%d/ground_truth/pose',robot_name,i));
            else
                error('cannot create pose subscriber');
            end
            
            % Subscribe Robot Odo
            if (topicRegistered(sprintf('/%s_%d/ground_truth/odometry',robot_name,i)))
                agent.odom_sub = rossubscriber(sprintf('/%s_%d/ground_truth/odometry',robot_name,i));
            else
                error('cannot create odom subscriber');
            end
        else
            
            if i <= n_CF
                agent.type = 1;
                
                switch (MAS.Aerial_HW)
                    
                    case 'CF'
                        % Control purpose
                        agent.pose_sub = rossubscriber(sprintf('/CF%d/pose',RobCFs(i)));
                        agent.control_pub = rospublisher(sprintf('/CF%d/goal',RobCFs(i)));
                        agent.control_msg = rosmessage(agent.control_pub);
                        
                        % Speed data
                        agent.vel_sub = rossubscriber(sprintf('/CF%d/vel',RobCFs(i)));
                        
                        % Service activation, security purpose
                        agent.rob_client_takeoff = rossvcclient(sprintf('/CF%d/takeoff',RobCFs(i)));
                        agent.rob_takeoff = rosmessage(agent.rob_client_takeoff);
                        agent.rob_client_land = rossvcclient(sprintf('/CF%d/land',RobCFs(i)));
                        agent.rob_land = rosmessage(agent.rob_client_land);
                        agent.rob_client_stop = rossvcclient(sprintf('/CF%d/stop',RobCFs(i)));
                        agent.rob_stop = rosmessage(agent.rob_client_stop);
                        
                    case 'DJI'
                        error('DJI Not Available Yet!')
                        
                end
                
            else
                agent.type = 2;
                switch (MAS.Ground_HW)
                    
                    case 'Saetta'
                        
                        % Control purpose
                        agent.pose_sub = rossubscriber(sprintf('/robot_%d/pose',RobSAs(i-n_CF)));
                        agent.control_pub = rospublisher(sprintf('/robot_%d/cmd_vel',RobSAs(i-n_CF)));
                        agent.control_msg = rosmessage(agent.control_pub);
                        
                end
                
            end
        end
    end
    
    % Store Agent
    MAS.agents{i} = agent;
    
end


end