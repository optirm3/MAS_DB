% Return the odometry for the i-th agent

function [odom, speed, agents] = getAgentOdom(agents,i,gazebo)

pose_msg=agents{i}.pose_sub.LatestMessage;

time = 0;
time = pose_msg.Header.Stamp;
time = double(time.Sec)+double(time.Nsec)*10^-9;

% Pose X
odom.xyz(1)=pose_msg.Pose.Position.X;
% Pose Y
odom.xyz(2)=pose_msg.Pose.Position.Y;
% Pose Z
odom.xyz(3)=pose_msg.Pose.Position.Z;
% Quaternion
Q.X = pose_msg.Pose.Orientation.X;
Q.Y = pose_msg.Pose.Orientation.Y;
Q.Z = pose_msg.Pose.Orientation.Z;
Q.W = pose_msg.Pose.Orientation.W;

% Representing Attitude: Euler Angles, Unit Quaternions, and Rotation Vectors
% James Diebel, equation 290 used to convert quaternion to rpy

% From quaternion to Roll
odom.rpy(1) = atan2(2.0*(Q.Y*Q.Z+Q.W*Q.X),Q.Z*Q.Z-Q.Y*Q.Y-Q.X*Q.X+Q.W*Q.W);
% From quaternion to Pitch
%  values > 1 produce complex results -> NEED TO FIX? check quat2eul
odom.rpy(2) = -asin(2.0*(Q.X*Q.Z-Q.W*Q.Y));
% Pose w (From quaternion to Yaw)
odom.rpy(3) = atan2(2.0*(Q.X*Q.Y+Q.W*Q.Z),Q.X*Q.X+Q.W*Q.W-Q.Z*Q.Z-Q.Y*Q.Y);

if gazebo
    speed_msg = agents{i}.odom_sub.LatestMessage;
    speed.xyz(1) = speed_msg.Twist.Twist.Linear.X;
    speed.xyz(2) = speed_msg.Twist.Twist.Linear.Y;
    speed.xyz(3) = speed_msg.Twist.Twist.Linear.Z;
    
    speed.rpy(1) = speed_msg.Twist.Twist.Angular.X;
    speed.rpy(2) = speed_msg.Twist.Twist.Angular.Y;
    speed.rpy(3) = speed_msg.Twist.Twist.Angular.Z;
else
    last_xyz = agents{i}.last_xyz;
    last_rpy = agents{i}.last_rpy;
    last_time = agents{i}.last_time;
    dt = time - last_time;
    
    speed.xyz(1) = (odom.xyz(1) - last_xyz(1))/dt;
    speed.xyz(2) = (odom.xyz(2) - last_xyz(2))/dt;
    speed.xyz(3) = (odom.xyz(3) - last_xyz(3))/dt;
    
    speed.rpy(1) = (odom.rpy(1) - last_rpy(1))/dt;
    speed.rpy(2) = (odom.rpy(2) - last_rpy(2))/dt;
    speed.rpy(3) = (odom.rpy(3) - last_rpy(3))/dt;
    
    agents{i}.last_xyz = odom.xyz;
    agents{i}.last_rpy = odom.rpy;
    
    new_time = 0;
    new_time = pose_msg.Header.Stamp;
    new_time = double(new_time.Sec)+double(new_time.Nsec)*10^-9;
    agents{i}.last_time = new_time;
    
    % Presa dal topic vel
    vel_msg = agents{i}.vel_sub.LatestMessage;
    speed.vel_xyz(1) = vel_msg.Twist.Linear.X;
    speed.vel_xyz(2) = vel_msg.Twist.Linear.Y;
    speed.vel_xyz(3) = vel_msg.Twist.Linear.Z;
    
    speed.vel_rpy(1) = vel_msg.Twist.Angular.X;
    speed.vel_rpy(2) = vel_msg.Twist.Angular.Y;
    speed.vel_rpy(3) = vel_msg.Twist.Angular.Z;
    
end

end