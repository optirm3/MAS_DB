%Function to generate the initial robots conditions
function [pose,A]=initAgentsPose(n,d,s,l,rho,eta)


xyz = zeros(n,3);
rpy = zeros(n,3);

%Do while
disp('trying...')
while (1)
    %generate randome conditions
    xyz(:,1:d)=round((l-1)*rand(n,d))+rand(n,d);
    if (s>0)
        rpy(:,1:s) = 2*pi*rand(n,d);
    end
    %Compute the Adjacency matrix
    A=adjancencyMatrix(xyz,rho);
    % Compute the Laplacian Matrix
    L = diag(sum(A,1))-A;
    %If connected -> break, else -> continue
    if rank(L) == n-1; break; end
end

pose.xyz = xyz;

% pose.xyz = initRadiusPose(n-1,l);
% pose.xyz(10,1:3) = [0 0 0];

% pose.xyz = [ 4.6022    6.4714         0
%     4.5868    6.3358         0
%     4.4160    6.2759         0
%     4.7012    6.1218         0
%     4.8624    6.0735         0
%     4.3243    6.5527         0
%     -2.4609    3.3411         0
%     -2.5702    3.2074         0
%     -2.3225    3.1917         0
%     -2.2847    3.4384         0];
    
pose.rpy= rpy;

fprintf('\nconnected!\n')


end