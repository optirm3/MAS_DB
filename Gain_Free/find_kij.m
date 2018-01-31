function [ K, dot_kij_scaled ] = find_kij( MAS, m, i, j, K, Vij, DF_dx )

% DV_dxi = grad_V1_xi(MAS, i);    
% DV_dxj = grad_V1_xi(MAS, j);
% DV_dkij = grad_V1_kij(Vij, K,i, j);     
% DF_dxi = [DF_dx(2*i-1); DF_dx(2*i)];
% DF_dxj = [DF_dx(2*j-1); DF_dx(2*j)];

% % DF_dkij = grad_V2_kij(m, MAS.n, MAS.agents, i, j, K, MAS.d);
DF_dkij = grad_V2_kij_Matteo(MAS, m, i, j, K);

% if (abs(DV_dkij+DF_dkij) < 0.01)
%     fprintf(2,'Iteration %d \t\t\t DV1_dkij + DV2_dkij   %g\n', MAS.iter, DV_dkij+DF_dkij );
%     1+1;
% end

% % Neighborhoods
% Ni = length(MAS.agents{i}.nbrs);
% Nj = length(MAS.agents{j}.nbrs);
% 
% % Kij Control Law
% wij = (DV_dkij'*DF_dkij +2*((DF_dxi'*DV_dxi)/Ni + (DF_dxj'*DV_dxj)/Nj))/(DV_dkij + DF_dkij);

% Modifica 20 gennaio
% dot_kij = (-DF_dkij +wij)/norm(DF_dkij);
% Modifica 22 gennaio
% dot_kij = (-DF_dkij + wij)/norm(wij - DF_dkij);
% Standard
dot_kij = -DF_dkij;% + wij;
dot_kij_scaled = dot_kij*MAS.kdt;

% Update Kij Gains
K(i,j) = K(i,j) + dot_kij_scaled;
K(j,i) = K(i,j);

end