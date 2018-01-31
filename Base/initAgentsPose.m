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
pose.rpy= rpy;

fprintf('\nconnected!\n')


end