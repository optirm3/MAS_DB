function [ MAS, u_opt, DF_dx, dot_k_matrix ] = optimizeGains(MAS, Vij, m)

N = MAS.n;
G = MAS.A;
count = 0;
K = ones(N,N);
u_opt = zeros(2,N);
edges = sum(sum(G))/2;
dot_k = zeros(1,edges);
DF_dx = grad_V2_x(MAS, m);
base_k = MAS.k;
k_iter = MAS.k_iter;
k_current = MAS.k_current;
dot_k_matrix = zeros(N);

if (MAS.opt)
    
    % Compute Gains
    for i=1:N-1
        for j=(i+1):N
            if(~isempty(m{i,j}))
                K = base_k;
                count = count + 1;
                for iter=1:k_iter
                    [K, dot_k_e_ij] = find_kij(MAS, m, i, j, K, Vij, DF_dx);
                end
                dot_k(count) = dot_k_e_ij;
                dot_k_matrix(i,j) = dot_k_e_ij;
                k_current(i,j) = K(i,j);
                k_current(j,i) = K(j,i);
            end
        end
    end
    dot_k_matrix = dot_k_matrix + dot_k_matrix';
    
    % Compute New Control Actions
    u_opt = computeUOpt(MAS,K,m);
    
    % Save Gains and Input Actions
    MAS.k = k_current;
    
    for i=1:N
        MAS.agents{i}.u = u_opt(:,i);
        MAS.agents{i}.u_opt = u_opt(:,i);
    end
    
    MAS.u_opt = u_opt;
    MAS.u = u_opt;
    
else
    % Compute classical control action
    a = MAS.a;
    b = MAS.b;
    xyz = MAS.pose.xyz;
    % For each agent 
    for i=1:N
        xy_ref = zeros(1,2);
        % For each agent's neighboor
        for j = 1:N
            if i==j
                continue
            end
            % If the agents are connected
            if ~isempty(m{i,j})
                xy_ref = xy_ref - a*(xyz(i,1:2)-xyz(j,1:2));
                xy_ref = xy_ref + b*(xyz(i,1:2)-xyz(j,1:2))/norm(xyz(i,1:2)-xyz(j,1:2))^2.5;
            end
        end
        MAS.agents{i}.u = xy_ref';
    end
    
    for i=1:N
        u_opt(:,i) = MAS.agents{i}.u;
    end
    
    MAS.u_opt = u_opt;
    MAS.u = u_opt;

end