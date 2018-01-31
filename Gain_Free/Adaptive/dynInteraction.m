function [ agents, m, Vij ] = dynInteraction( agents, N, i, G, dist, ndist, sim, m, Vij )

u_aggregation = [0; 0];

for j=1:N
    
   if(j==i)
       continue;
   end
   
    nrij = ndist(i,j);
    rij = dist{i,j};
    
    if(G(i,j) > 0)        
        Vij(i,j) = computePotential(sim,nrij);
        m{i,j} = -computePotentialGradient(sim,nrij,rij);       
        u_aggregation = u_aggregation + m{i,j};
            
    end
    
end

% Apply controls, single integrator dynamics
agents{i}.u = u_aggregation;


end

