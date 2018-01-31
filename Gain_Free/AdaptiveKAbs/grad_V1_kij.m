function [DV1_dkij] = grad_V1_kij(Vij, K, i, j)

DV1_dkij = sign(K(i,j))*Vij(i,j) + sign(K(j,i))* Vij(j,i);

end