
function [MAS] = agentDynamicsControl(MAS)

%% Local Variables
n = MAS.n;                      % Number of Agents

alpha = 2;
kp = alpha*0.02;
kd = alpha*0.06;

k1 = 1;
k2 = 2.2;

k3=0.13;
k4=0.52;

for i=1:n        
    u = zeros(1,MAS.d);    
    u(1) = (kp*MAS.agents{i}.vel_ref.linear(1) - kd*MAS.speed.xyz(i,1));
    u(2) = (kp*MAS.agents{i}.vel_ref.linear(2) - kd*MAS.speed.xyz(i,2));
    u(3) = k1*MAS.agents{i}.vel_ref.linear(3) - k2*MAS.speed.xyz(i,3) + 15.15;                
    u(4) = k3*MAS.agents{i}.vel_ref.angular(3) - k4*MAS.speed.rpy(i,3);
    
    MAS.agents{i}.u = u;
end


end