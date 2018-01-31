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
        
        if i==j
            continue
        end
        
        if(~isempty(fm{i,j}))
            d = dist{i,j};
            m = fm{i,j};
            P_ij = (1/(d'*d))*(u_opt(:,i)'*d)*d;
        else
            if MAS.d == 2
                d = [rho; 0];
            else
                d = [rho; 0; 0];
            end
            m  = MAS.a*d - (MAS.b*d)/norm(d)^2.5;
            Vij(i,j) = (1/2)*MAS.a*(rho^2) + 2*MAS.b*(1/(rho^(1/2)));
            P_ij = [0; 0];
        end
        
        V1 = V1 + K(i,j)^2*Vij(i,j);
        V2 = V2 + (1/2)*(norm(P_ij - m))^2;
                
    end
end

V =  V + V1 + V2;
end