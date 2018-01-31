function [MAS] = initMATLAB(MAS)

n = MAS.n;
speed.xyz = [0 0 0];
speed.rpy = [0 0 0];
linear_speed = zeros(n,3);
rpy_speed = zeros(n,3);

% Agent Location Random Generation
[pose,G] = initAgentsPose(MAS.n,MAS.d,MAS.s,MAS.l,MAS.rho,MAS.eta);

for i=1:n
    agent.id = i;
    agent.rho0 = MAS.rho0;
    agent.rho = MAS.rho;
    agent.u = zeros(MAS.d,1);
    agent.u_opt = zeros(MAS.d,1);
    agent.vel_ref.linear = zeros(1,3);
    agent.vel_ref.angular = zeros(1,3);
    agent.nbrs = double(find(G(i,:)==1));
    
    agent.pose.xyz = pose.xyz(i,:);             % Agent Pose Data Structure
    agent.pose.rpy = pose.rpy(i,:);             % Agent Pose Data Structure
    agent.speed = speed;
    %     linear_speed(i,:) = [speed.xyz(1) speed.xyz(2) speed.xyz(3)];
    %     rpy_speed(i,:) = [speed.rpy(1) speed.rpy(2) speed.rpy(3)];
    
    MAS.agents{i} =  agent;     % Store Agent Data Structure
end

%% Data Structure
MAS.pose = pose;
MAS.speed.xyz = linear_speed;
MAS.speed.rpy = rpy_speed;

end