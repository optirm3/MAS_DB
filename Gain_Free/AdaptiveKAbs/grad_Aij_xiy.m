function [ d_Aij_xiy ] = grad_Aij_xiy( d, Aij )

d_Aij_xiy = ((1/norm(d)^2)*[0, d(1); d(1), 2*d(2)] -(2*d(2)/norm(d)^2)*Aij);

end


