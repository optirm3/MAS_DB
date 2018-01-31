function [DV1_dxi] = grad_V1_xi(MAS, i)

DV1_dxi = -MAS.agents{i}.u;

end