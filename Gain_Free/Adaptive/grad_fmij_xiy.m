function [ d_fmij_xiy ] = grad_fmij_xiy( a, b, d )

d_fmij_xiy = [-(2.5*b*d(1)*d(2))/norm(d)^4.5; (-a + (b/norm(d)^2.5) - ((2.5*b*d(2)^2)/norm(d)^4.5))];

end

