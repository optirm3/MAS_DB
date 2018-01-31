% This code perform a time-simulation
function [MAS] = simMAS(MAS)


%% Local Variables
% Sampling Time
dt = MAS.dt;
% Total Time
t = MAS.t;
% Current Time
ct = 0;


if (MAS.ROS)
    
    reset(MAS.r)
    disp('Started!')
    %% Simulation Loop
    while MAS.r.TotalElapsedTime < t-dt
        
        MAS.iter = MAS.iter+1;
        
        %% Time Update
        ct = ct + dt;
        MAS.ct = ct;
        
        %% Compute Neighborhood
        MAS = computeNeighborhoods(MAS);
        
        %% Perform Simulation Step
        MAS = updateMAS(MAS);
        
        %% Collect Data [Not Implemented Yet]
        
        %% Update Graphics
        MAS = updateGraphics(MAS);
        
        %% Synchronize to Gazebo
        %     time = MAS.r.TotalElapsedTime;
        %     fprintf('Iteration: %d - Time Elapsed: %f\n',MAS.iter,time)
        waitfor(MAS.r);
    end
    
    fprintf('Outside -- Time Elapsed: %f\n', MAS.r.TotalElapsedTime)
    
else
    
    %% Simulation Loop
    while ct<t-dt
        
        MAS.iter = MAS.iter+1;
        
        %% Time Update
        ct = ct + dt;
        MAS.ct = ct;
        
        %% Compute Neighborhood
        MAS = computeNeighborhoods(MAS);
        
        %% Perform Simulation Step
        MAS = updateMAS(MAS);
        
        %% Collect Data [Not Implemented Yet]
        
        %% Update Graphics
        MAS = updateGraphics(MAS);
        
    end
    
    pause(MAS.dt);
    
end

end