function [MAS] = agentDynamicsIntegration(MAS)

%% Local Variables
n = MAS.n;                  % Number of Agents
dt = MAS.dt;                % Sampling Time
d = MAS.d;                  % Sampling Time

% For each agent
for i=1:n
    
    agent = MAS.agents{i};
    
    %% Perform Discrete Dynamic Integration [For now only xyz]
    
    slow_factor = 1;
    
    MAS.pose.xyz(i,1:d) = agent.pose.xyz(1:d) + slow_factor*agent.u(1:d)'*dt;
    MAS.speed.xyz(i,1:d) = agent.u';
    
    %% Update Data Structure
    MAS.agents{i} = agent;
    
end
end