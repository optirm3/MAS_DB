function [u_opt] = computeUOpt(MAS,K,m)

N = MAS.n;

u_opt = zeros(2,N);
% Compute New Control Actions
for i=1:N-1
    for j=(i+1):N
        if(~isempty(m{i,j}))
            if(~MAS.SMOOTH_EQUILIBRIUM || (MAS.SMOOTH_EQUILIBRIUM && ...
                    norm(MAS.agents{i}.pose.xyz(1:MAS.d)-MAS.agents{j}.pose.xyz(1:MAS.d)) > 0.5*MAS.agents{i}.rho0))
                u_opt(:,i) = u_opt(:,i) + K(i,j)^2*m{i,j};
                u_opt(:,j) = u_opt(:,j) + K(j,i)^2*m{j,i};
            end
        end
        
    end
    
end