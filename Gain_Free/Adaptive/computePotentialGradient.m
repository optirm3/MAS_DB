function [grad_xi_Vij] = computePotentialGradient(a, b, nrij, rij)

grad_xi_Vij = a*rij - (b*rij)/nrij^2.5;

end