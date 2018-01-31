function [ DF_dx ] = grad_V2_x( MAS, m )

N = MAS.n;
k = MAS.k;
DU_dx = cell(N,1);
DP_dx = cell(N,N);
Dm_dx = cell(N,N);
DA_dx_u = cell(N,N);
DF_dx = zeros(1,2*N);
agents = MAS.agents;
a = MAS.a;
b = MAS.b;

for i=1:N
    
    D_Ui_dx = zeros(2, 2*N);
    
    for j=1:N
        
        if(~isempty(m{i,j}))
            DAij_dx_u = zeros(2, 2*N);
            x_ij = agents{i}.pose.xyz(1:MAS.d)' - agents{j}.pose.xyz(1:MAS.d)';
            Aij = (1/norm(x_ij)^2)*(x_ij*x_ij');
            % Gradient of Aij with respect x 
            D_Aij_xix = grad_Aij_xix(x_ij, Aij);
            D_Aij_xiy = grad_Aij_xiy(x_ij, Aij);
            D_Aij_xjx = grad_Aij_xix(-x_ij, Aij);
            D_Aij_xjy = grad_Aij_xiy(-x_ij, Aij);
            DAij_dx_u(:,2*i - 1) = D_Aij_xix*agents{i}.u;
            DAij_dx_u(:,2*i) = D_Aij_xiy*agents{i}.u;
            DAij_dx_u(:,2*j - 1) = D_Aij_xjx*agents{i}.u;
            DAij_dx_u(:,2*j) = D_Aij_xjy*agents{i}.u;
            DA_dx_u{i,j} = DAij_dx_u;
            % Gradient of u_i with respect x            
            D_Ui_dx(:,2*i - 1) = D_Ui_dx(:,2*i - 1) + grad_Ui_xix(a, b, k(i,j), x_ij);
            D_Ui_dx(:,2*i) = D_Ui_dx(:,2*i) + grad_Ui_xiy(a, b, k(i,j), x_ij);
            D_Ui_dx(:,2*j - 1) = -grad_Ui_xix(a, b, k(i,j), x_ij);
            D_Ui_dx(:,2*j) = -grad_Ui_xiy(a, b, k(i,j), x_ij);
            % Gradient of m_ij with respect x
            D_mij_x = zeros(2, 2*N);
            D_mij_x(:,2*i - 1) = grad_fmij_xix(a, b, x_ij);
            D_mij_x(:,2*i) = grad_fmij_xiy(a, b, x_ij);
            D_mij_x(:,2*j - 1) = -grad_fmij_xix(a, b, x_ij);
            D_mij_x(:,2*j) = -grad_fmij_xiy(a, b, x_ij);
            Dm_dx{i,j} = D_mij_x;
        end
        
    end
    
    DU_dx{i} = D_Ui_dx;
    
end



%% D/dx (F)

for i=1:N
    for j=1:N
        
        if(~isempty(m{i,j}))
            x_ij = agents{i}.pose.xyz(1:MAS.d)' - agents{j}.pose.xyz(1:MAS.d)';
            Aij = (1/norm(x_ij)^2)*(x_ij*x_ij');
            Pij = Aij*agents{i}.u;
            DP_dx{i,j} = DA_dx_u{i,j} + Aij*DU_dx{i};
            DF_dx = DF_dx + (Pij - m{i,j})'*(DP_dx{i,j} - Dm_dx{i,j});
        end
        
    end
end


end

