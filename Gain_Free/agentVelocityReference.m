function [MAS] = agentVelocityReference(MAS)

%% Local Variables
N = MAS.n;                      % Number of Agents
d = MAS.d;
xyz = MAS.pose.xyz;             % Pose
rpy = MAS.pose.rpy;             % Pose
dist = cell(N);
ndist = zeros(N);

%% Compute distances
for i=1:N
    for j=i+1:N
        dist{i,j} = (xyz(i,1:d)-xyz(j,1:d))';
        dist{j,i} = -dist{i,j};
        ndist(i,j) = norm(dist{i,j});
        ndist(j,i) = ndist(i,j);
    end
end
MAS.distHist{MAS.iter} = dist;


%% Compute Basic Control Term
[MAS, m, Vij] = dynInteraction(MAS, dist, ndist);
MAS.m_ijHist{MAS.iter} = m;

%% Optimization
[MAS, u_opt, DF_dx, dot_k] = optimizeGains(MAS, Vij, m);

%% Update velocity
% [agents] = Update_vel(agents, u_opt, N, dt);

%% Data for Lyapunov stability
[V, V1, V2] = LyapunovAnalysis(MAS, u_opt, Vij, m, dist);
MAS.V1Hist(MAS.iter) = V1;
MAS.V2Hist(MAS.iter) = V2;
MAS.VHist(MAS.iter) = V;

% F = test2_20Gen(MAS,dist,m);
% MAS.diffStory(MAS.iter) = V2-F;

%% Lyapunov Gradients Analysis
[DV] = LyapunovGradientAnalysis(MAS, Vij, m, u_opt, DF_dx, dot_k);
MAS.HistDPhi(MAS.iter) = DV;

%% Hessian Analysis
if MAS.HessianAnalysis
    isSDP = HessianAnalysis(MAS,m,dist);
    if ~isSDP
        fprintf('%0.2f \t %s\n',MAS.ct,'Hessian not semidefinite positive')
    else
        fprintf('%0.2f \t %s\n',MAS.ct,'Hessian semidefinite positive')
    end
end

%% References

z_des = 0.7*ones(1,N);
yaw_des = 0;

for i=1:N
    z_ref = -(xyz(i,3) - z_des(i));
    
    yaw = rpy(i,3);
    yaw_ref = -(yaw-yaw_des);
    
    % Store Control Action
    MAS.agents{i}.vel_ref.linear = [u_opt(:,i)' z_ref];
    MAS.agents{i}.vel_ref.angular = [0 0 yaw_ref];
end


end