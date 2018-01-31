function [ d_Ui_xix ] = grad_Ui_xix( a, b, k, d )

d_Ui_xix = [k^2*(-a + (b/norm(d)^2.5) - ((2.5*b*d(1)^2)/norm(d)^4.5)); k^2*(2.5*b*d(1)*d(2))/norm(d)^4.5];

end

