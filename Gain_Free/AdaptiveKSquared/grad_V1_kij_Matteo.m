function [DV1_dkij] = grad_V1_kij_Matteo(N, Vij, K, i, j)

DV1_dkij = 2*K(i,j)*Vij(i,j) + 2*K(j,i)* Vij(j,i);

% DV1_dkij = 0;
% 
% for h=1:N
%     
%     if(Vij(i,h))
%         DV1_dkij = DV1_dkij + 2*K(i,h)*Vij(i,h);
%     end
%     
%     if(Vij(j,h))
%         DV1_dkij = DV1_dkij + 2*K(j,h)*Vij(j,h);
%     end
%     
% end

end