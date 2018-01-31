function Hessian = Hessian_Function(k,lambda,m,G,AB)%,gradGradGammaGain)

%% Hessian of objective function
Hessian = 0;
N = length(m);
gammaGain = k.^2;
gradGammaGain = 2*diag(k);
%gradGradGammaGain is Edges x Edges x Edges

for i=1:N
    for j=1:N
        
        if G(i,j)>0
            
            P = (gammaGain'*AB{i,j}' - m{i,j}') * AB{i,j};
            
            %Hessian = Hessian + (gradGammaGain')*AB{i,j}'*AB{i,j}*gradGammaGain + prodMultiDim(P,gradGradGammaGain);
            Hessian = Hessian + (gradGammaGain')*AB{i,j}'*AB{i,j}*gradGammaGain + prodMultiDimOPT(P);
            
        end
        
    end
end


end