function [DV2_dkij] = grad_V2_kij_Matteo(MAS, fm, i, j, k_prev)

N = MAS.n;
dim = MAS.d;
agents = MAS.agents;

% Indexes
c_i = 0;
c_j = 0;
% Output
DV2_dkij = 0;
% Neighborhoods
Ni = length(agents{i}.nbrs);
Nj = length(agents{j}.nbrs);
% Matrices
A_ih = cell(N,1);
A_jh = cell(N,1);
B_i = zeros(dim,Ni);
B_j = zeros(dim,Nj);
K_i = zeros(Ni,1);
K_j = zeros(Nj,1);
DK_i = zeros(Ni,1);
DK_j = zeros(Nj,1);

for h=1:N
    
    if(~isempty(fm{i,h}))
        c_i = c_i+1;
        d_ih = agents{i}.pose.xyz(1:dim)' - agents{h}.pose.xyz(1:dim)';
        A_ih{h} = (1/(d_ih'*d_ih))*(d_ih*d_ih');
        K_i(c_i) = k_prev(i,h);
        B_i(:,c_i) = fm{i,h};
        
        if h==j
            DK_i(c_i) = sign(K_i(c_i));
        end
    end
    
end


for h=1:N
    
    if(~isempty(fm{j,h}))
        c_j = c_j+1;
        d_jh = agents{j}.pose.xyz(1:dim)' - agents{h}.pose.xyz(1:dim)';
        A_jh{h} = (1/(d_jh'*d_jh))*(d_jh*d_jh');
        K_j(c_j) = k_prev(j,h);
        B_j(:,c_j) = fm{j,h};
        
        if h==i
            DK_j(c_j) = sign(K_j(c_j));
        end
    end
    
end



for h=1:N
    
    if(~isempty(fm{i,h}))
        DV2_dkij = DV2_dkij + 1/2*((abs(K_i))'*B_i'*A_ih{h}'*A_ih{h}*B_i*DK_i - fm{i,h}'*A_ih{h}*B_i*DK_i);
    end
    
    if(~isempty(fm{j,h}))
        DV2_dkij = DV2_dkij + 1/2*((abs(K_j))'*B_j'*A_jh{h}'*A_jh{h}*B_j*DK_j - fm{j,h}'*A_jh{h}*B_j*DK_j);
    end
    
end


end