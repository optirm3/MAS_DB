function [V, V1, V2] = LyapunovAnalysis(MAS, u_opt, Vij, fm, dist)

N = MAS.n;
K = MAS.k;
rho = MAS.rho;

V = 0;
V1 = 0;
V2 = 0;

%% V1 && V2
for i=1:N
    for j=1:N
        
        if(~isempty(fm{i,j}))
            d = dist{i,j};
            P_ij = (1/(d'*d))*(u_opt(:,i)'*d)*d;
            V1 = V1 + abs(K(i,j))*Vij(i,j);                    %% DONE
            V2 = V2 + (1/2)*(norm(P_ij - fm{i,j}))^2;            
%         else
%             V = V + (sim.a/2)*sim.rho2^2 + 2*sim.b*(1/sim.rho2^0.5);
        end        
    end
end

V =  V + V1 + V2;
end