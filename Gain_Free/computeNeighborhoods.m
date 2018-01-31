% Function to compute the agents' neighborhoods

function [MAS] = computeNeighborhoods(MAS)

%% Local Variables
xyz = MAS.pose.xyz;
rho = MAS.rho;

%% Compute Adjacency Matrix
d = dist(xyz');
A = (d < rho);
A = A - eye(length(A),length(A));

%% Store Matrix
MAS.A = A;
MAS.graphHist{MAS.iter} = A;

end

%% Old version
% function [MAS] = computeNeighborhoods(MAS)
% 
% %% Local Variables
% xyz = MAS.pose.xyz;
% rho = MAS.rho;
% 
% MAS.A=adjancencyMatrix(xyz,rho);
% 
% 
% end