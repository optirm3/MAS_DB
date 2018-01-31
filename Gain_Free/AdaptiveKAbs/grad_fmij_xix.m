function [ d_fmij_xix ] = grad_fmij_xix( a, b, d )

d_fmij_xix = [(-a + (b/norm(d)^2.5) - ((2.5*b*d(1)^2)/norm(d)^4.5)); -(2.5*b*d(1)*d(2))/norm(d)^4.5];

end

