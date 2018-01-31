function [DV] = LyapunovGradientAnalysis(MAS, Vij, m, u_opt, DF_dx, dot_k)

N = MAS.n;
d = MAS.d;

DF_DX = reshape(DF_dx,[d N]);
DV1_dk = 0;
DV2_dk = 0;
DV1_dx = 0;
DV2_dx = 0;
K = MAS.k;

for i=1:N
    
    dx = u_opt(:,i)';
    
    for j=1:N

        if ~isempty(m{i,j})
            dk = dot_k(i,j);
            
            DV_dkij = grad_V1_kij(Vij, K, i, j);
            DF_dkij = grad_V2_kij_Matteo(MAS, m, i, j, K);
            
            DV1_dk = DV1_dk + DV_dkij*dk;
            DV2_dk = DV2_dk + DF_dkij*dk;
            
        end
        
    end
    
    DV1_dx = DV1_dx + dx*(-u_opt(:,i));
    DV2_dx = DV2_dx + dx*DF_DX(:,i);
    
end

DV_dx = DV1_dx + DV2_dx;
DV_dk = DV1_dk + DV2_dk;
DV = DV_dx + DV_dk;
end