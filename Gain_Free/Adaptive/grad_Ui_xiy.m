function [ d_Ui_xiy ] = grad_Ui_xiy( a, b, k, d )

d_Ui_xiy = [-(2.5*b*k*d(1)*d(2))/norm(d)^4.5; k*(-a + (b/norm(d)^2.5) - ((2.5*b*d(2)^2)/norm(d)^4.5))];

end

