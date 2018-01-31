function [MAS] = updateMAS(MAS)

%% Collect Latest Agents' Poses
MAS = updateAgentsData(MAS);

%% Compute Agent Velocity Reference
MAS = agentVelocityReference(MAS);

if MAS.ROS
    %% Compute Agent Actuation
    MAS = agentDynamicsControl(MAS);
    %% Send References to HW
    MAS = agentSendReferences(MAS);
else
    %% Perform Discrete Dynamics Integration
    MAS = agentDynamicsIntegration(MAS);
end

end