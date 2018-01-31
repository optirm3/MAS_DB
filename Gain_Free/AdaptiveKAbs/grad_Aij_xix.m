function [ d_Aij_xix ] = grad_Aij_xix( d, Aij )

d_Aij_xix = ((1/norm(d)^2)*[2*d(1), d(2); d(2), 0] -(2*d(1)/norm(d)^2)*Aij);

end

