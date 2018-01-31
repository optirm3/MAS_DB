function [F,Grad,Hessian] = F_Function_Hessian(k,m,G,AB)%,gradGradGammaGain)

F = 0;
Grad = 0;
Hessian = 0;
N = length(m);
gammaGain = k.^2;
gradGammaGain = 2*diag(k);
%gradGradGammaGain is Edges x Edges x Edges

for i=1:N
    for j=1:N
        
        if G(i,j)>0
            
            % Objective Function
            F = F + (1/2)*(norm(AB{i,j}*gammaGain - m{i,j})^2);
            
            % Gradient Required
            if nargout > 1
                
                Grad = Grad + (AB{i,j}*gammaGain - m{i,j})'*(AB{i,j}*gradGammaGain);
                
                % Hessian Required
                if nargout > 2
                    
                    P = (gammaGain'*AB{i,j}' - m{i,j}') * AB{i,j};
                    
                    %Hessian = Hessian + (gradGammaGain')*AB{i,j}'*AB{i,j}*gradGammaGain + prodMultiDim(P,gradGradGammaGain);
                    Hessian = Hessian + (gradGammaGain')*AB{i,j}'*AB{i,j}*gradGammaGain + prodMultiDimOPT(P);
                    
                end
                
            end
            
        end
        
    end
end

end