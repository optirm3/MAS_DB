function [DV2_dkij] = grad_V2_kij(fm, N, agents, i, j, k_prev, dim)

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
B_i = zeros(2,Ni);
B_j = zeros(2,Nj);
K_i = zeros(1,Ni);
K_j = zeros(1,Nj);

for h=1:N
    
    if(~isempty(fm{i,h}))
        c_i = c_i+1;
        d_ih = agents{i}.pose.xyz(1:dim)' - agents{h}.pose.xyz(1:dim)';
        A_ih{h} = (1/norm(d_ih)^2)*(d_ih*d_ih');
        K_i(c_i) = k_prev(i,h);
        B_i(:,c_i) = fm{i,h};
    end
    
end


for h=1:N
    
    if(~isempty(fm{j,h}))
        c_j = c_j+1;
        d_jh = agents{j}.pose.xyz(1:dim)' - agents{h}.pose.xyz(1:dim)';
        A_jh{h} = (1/norm(d_jh)^2)*(d_jh*d_jh');
        K_j(c_j) = k_prev(j,h);
        B_j(:,c_j) = fm{j,h};
    end
    
end



for h=1:N
    
    if(~isempty(fm{i,h}))
        DV2_dkij = DV2_dkij + 1/2*K_i.^2*B_i'*A_ih{h}'*A_ih{h}*B_i*K_i' - fm{i,h}'*A_ih{h}*B_i*K_i';
%         DV2_dkij = DV2_dkij + 1/2*K_i.^2*B_i'*A_ih{h}'*A_ih{h}*fm{i,j}*K_i' - fm{i,h}'*A_ih{h}*fm{i,j}*K_i';
%           DV2_dkij = DV2_dkij + (A_ih{h}*B_i*1/2*K_i.^2' - fm{i,j})'*(A_ih{h}*B_i*K_i');
    end
    
    if(~isempty(fm{j,h}))
        DV2_dkij = DV2_dkij + 1/2*K_j.^2*B_j'*A_jh{h}'*A_jh{h}*B_j*K_j' - fm{j,h}'*A_jh{h}*B_j*K_j';
%         DV2_dkij = DV2_dkij + 1/2*K_j.^2*B_j'*A_jh{h}'*A_jh{h}*fm{j,i}*K_j' - fm{j,h}'*A_jh{h}*fm{j,i}*K_j';
%           DV2_dkij = DV2_dkij + (A_jh{h}*B_j*1/2*K_j.^2' - fm{j,i})'*(A_jh{h}*B_j*K_j');
    end
    
end


end