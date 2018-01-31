function [MAS] = updateAgentsData(MAS)

%% Local Variables
n = MAS.n;
G = MAS.G;

%% Collect Latest Agents' Poses
if (MAS.ROS)
    
    xyz = zeros(n,3);
    rpy = zeros(n,3);
    linear_speed = zeros(n,3);
    rpy_speed = zeros(n,3);
    twist_linear = zeros(n,3);
    twist_angular = zeros(n,3);
    
    for i=1:n
        MAS.agents{i}.nbrs = double(find(G(i,:)==1));
        [pose, speed, MAS.agents] = getAgentOdom(MAS.agents,i,MAS.GAZEBO);
        MAS.agents{i}.pose = pose;
        MAS.agents{i}.speed = speed;
        xyz(i,:) = [pose.xyz(1) pose.xyz(2) pose.xyz(3)];
        rpy(i,:) = [pose.rpy(1) pose.rpy(2) pose.rpy(3)];
        linear_speed(i,:) = [speed.xyz(1) speed.xyz(2) speed.xyz(3)];
        rpy_speed(i,:) = [speed.rpy(1) speed.rpy(2) speed.rpy(3)];
        twist_linear(i,:) = [speed.vel_xyz(1) speed.vel_xyz(2) speed.vel_xyz(3)];
        twist_angular(i,:) = [speed.vel_rpy(1) speed.vel_rpy(2) speed.vel_rpy(3)];
    end
    
    % Store data
    MAS.pose.xyz = xyz;
    MAS.pose.rpy = rpy;
    MAS.speed.xyz = linear_speed;
    MAS.speed.rpy = rpy_speed;
    MAS.speed.vel_xyz = twist_linear;
    MAS.speed.vel_rpy = twist_angular;
    
else   
    % Agents discover their new position from MAS (the update happens in agentDynamicsIntegration)
    for i=1:n
        agent = MAS.agents{i};
        agent.nbrs = double(find(G(i,:)==1));
        agent.pose.xyz = MAS.pose.xyz(i,:);
        agent.pose.rpy = MAS.pose.rpy(i,:);
        agent.speed.xyz = MAS.speed.xyz(i,:);
        agent.speed.rpy = MAS.speed.rpy(i,:);
        MAS.agents{i} = agent;
    end
    
    xyz = MAS.pose.xyz;                         % Agents' Poses
    xyz_dist = dist(xyz');                      % Agents' Interdistances
    MAS.xyz_dist = xyz_dist;                    % Store data
    
end

MAS.poseHist{MAS.iter} = MAS.pose;
MAS.speedHist{MAS.iter} = MAS.speed;
MAS.uOptHist{MAS.iter} = MAS.u_opt;

end