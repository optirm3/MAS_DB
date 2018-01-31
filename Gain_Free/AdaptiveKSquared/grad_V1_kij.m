function [DV1_dkij] = grad_V1_kij(Vij, K, i, j)

DV1_dkij = 2*K(i,j)*Vij(i,j) + 2*K(j,i)*Vij(j,i);

end