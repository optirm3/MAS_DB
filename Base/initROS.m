function [MAS] = initROS(MAS)

%% 1. Connect to ROS
% First shutdown possible previous ROS initialization (let's start clean)
shutROS;
% Then initialize ROS:
% Set Environmental Variable of ROS MASTER
setenv('ROS_MASTER_URI',MAS.ROS_MASTER_URI)
% Set Environmental Variable of ROS Hostname IP
setenv('ROS_IP',MAS.ROS_IP)
% Set Environmental Variable
setenv('ROS_HOSTNAME',MAS.ROS_HOSTNAME)
% Init ROS
rosinit

% setenv('ROS_MASTER_URI','http://172.16.224.169:11311')
% setenv('ROS_IP','172.16.224.1')
% setenv('ROS_HOSTNAME','Air-di-Matteo.station')
% rosinit

% Set ROS Rate
i = 1;
max_i = 10;
try_again = true;

while i <= max_i && try_again
    try
        MAS.r = rosrate(1/MAS.dt);
        try_again = false;
    catch ME
        fprintf('%s Fail #%d... \n',ME.message, i);
    end
    i = i+1;
    pause(0.25)
end
if i>max_i
    error('Check ROS connection');
else
    fprintf('\n');
end


%% Local Variabiles
n = MAS.n;

% Collect Latest Agents' Poses
xyz = zeros(n,3);
rpy = zeros(n,3);
linear_speed = zeros(n,3);
rpy_speed = zeros(n,3);
twist_linear = zeros(n,3);
twist_angular = zeros(n,3);

%% Subscribe ROS Topics
% Create the structure agents
MAS = initAgents(MAS);

pause(0.2)

% Get agents odometry
if MAS.GAZEBO
    for i=1:n
        [pose, speed] = getAgentOdom(MAS.agents,i);
        MAS.agents{i}.pose = pose;
        MAS.agents{i}.speed = speed;
        xyz(i,:) = [pose.xyz(1) pose.xyz(2) pose.xyz(3)];
        rpy(i,:) = [pose.rpy(1) pose.rpy(2) pose.rpy(3)];
        linear_speed(i,:) = [speed.xyz(1) speed.xyz(2) speed.xyz(3)];
        rpy_speed(i,:) = [speed.rpy(1) speed.rpy(2) speed.rpy(3)];
    end
else
    for i=1:n
        MAS.agents{i}.last_xyz = zeros(1,3);
        MAS.agents{i}.last_rpy = zeros(1,3);
        temp_time = rostime('now');
        temp_time = double(temp_time.Sec)+double(temp_time.Nsec)*10^-9;
        MAS.agents{i}.last_time = temp_time;
        [pose, velocity, MAS.agents] = getAgentOdom(MAS.agents,i,MAS.GAZEBO);
        MAS.agents{i}.pose = pose;
        speed.xyz = zeros(1,3);
        speed.rpy = zeros(1,3);
        speed.vel_xyz = velocity.vel_xyz;
        speed.vel_rpy = velocity.vel_rpy;
        MAS.agents{i}.speed = speed;
        xyz(i,:) = [pose.xyz(1) pose.xyz(2) pose.xyz(3)];
        rpy(i,:) = [pose.rpy(1) pose.rpy(2) pose.rpy(3)];
        linear_speed(i,:) = [speed.xyz(1) speed.xyz(2) speed.xyz(3)];
        rpy_speed(i,:) = [speed.rpy(1) speed.rpy(2) speed.rpy(3)];
        twist_linear(i,:) = [speed.vel_xyz(1) speed.vel_xyz(2) speed.vel_xyz(3)];
        twist_angular(i,:) = [speed.vel_rpy(1) speed.vel_rpy(2) speed.vel_rpy(3)];
    end
end

%% Data Structure
MAS.pose.xyz = xyz;
MAS.pose.rpy = rpy;
MAS.speed.xyz = linear_speed;
MAS.speed.rpy = rpy_speed;
MAS.speed.vel_xyz = twist_linear;
MAS.speed.vel_rpy = twist_angular;

pause(0.5);

%% Call service TAKEOFF
if (MAS.ROS && (~MAS.GAZEBO))
    for i=1:n
        if MAS.agents{i}.type == 1
            takeoffRequest(MAS.agents{i});
        end
    end
end

end