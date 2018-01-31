function [DV1_dkij] = grad_V1_kij(Vij, K, i, j)

DV1_dkij = Vij(i,j) + Vij(j,i);

end