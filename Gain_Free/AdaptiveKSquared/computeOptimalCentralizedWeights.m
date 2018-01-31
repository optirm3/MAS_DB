function [u_opt, sim]=computeOptimalCentralizedWeights(N,numEdges,m,agents,G,sim)

    %% Centralized Optimization
    %     x = lsqlin(C,d,A,b,Aeq,beq,lb,ub)
    % ||C  x - d||^2
    X = []; %zeros(2*numEdge,numEdge);
    y = []; %zeros(2*numEdge,1);
    
    B = cell(N,1);
    c=0;
    for i=1:N
        B{i} = zeros(2,numEdges);
        for j=i+1:N
            if (G(i,j)>0)
                c=c+1;
                B{i}(:,c)=m{i,j};
            end
        end
    end
    
    
    Gu=triu(G);
    for i=1:N
        for j=i+1:N
            if (G(i,j)>0)
                x_ij = agents{i}.pos - agents{j}.pos;
                Aij = (1/norm(x_ij)^2)*(x_ij*x_ij');
                X = [X;  -Aij*B{i}];
                y = [y; m{i,j}];
            end
            
        end
    end
    
    C = -X;
    d = y;
    options = optimoptions('lsqlin','Algorithm','interior-point','Display','none');
    ksq = lsqlin(C,d,[],[],[],[],zeros(numEdges,1),[],[],options);
    
    
    %
    c=0;
    for i=1:N
        for j=i+1:N
            if (G(i,j)>0)
                c=c+1;                
                K(i,j) = sqrt(2*ksq(c));
                K(j,i) = K(i,j);
                    sim.k_current(i,j) = K(i,j);
                    sim.k_current(j,i) = K(j,i);                
            end
        end
    end
    
    u_opt = computeUOpt(sim,agents,K,m);
    
end