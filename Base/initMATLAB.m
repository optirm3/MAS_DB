function [MAS] = initMATLAB(MAS)

n = MAS.n;
d = MAS.d;
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
    agent.u = zeros(d,1);
    agent.u_opt = zeros(d,1);
    agent.vel_ref.linear = zeros(1,3);
    agent.vel_ref.angular = zeros(1,3);
    agent.nbrs = double(find(G(i,:)==1));
    
    agent.pose.xyz = pose.xyz(i,:);             % Agent Pose Data Structure
    agent.pose.rpy = pose.rpy(i,:);             % Agent Pose Data Structure
    agent.speed = speed;
    
    MAS.agents{i} =  agent;     % Store Agent Data Structure
end

%% Data Structure
MAS.u_opt = zeros(d,n);
MAS.pose = pose;
MAS.speed.xyz = linear_speed;
MAS.speed.rpy = rpy_speed;

end