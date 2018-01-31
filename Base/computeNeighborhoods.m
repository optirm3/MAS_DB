% Function to compute the agents' neighborhoods

function [MAS] = computeNeighborhoods(MAS)

%% Local Variables
xyz = MAS.pose.xyz;
rho = MAS.rho;

%% Compute Adjacency Matrix
d = dist(xyz');
G = (d < rho);
G = G - eye(size(G));

%% Store Matrix
MAS.G = G;
MAS.graphHist{MAS.iter} = G;

end