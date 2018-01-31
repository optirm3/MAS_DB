function P = compute_Pij( N, edge, agents, m )

c = 0;
P = zeros(1, 2*edge);


for i=1:N
    for j=1:N
        
        if(~isempty(m{i,j}))
            c = c+1;
            x_ij = agents{i}.pos - agents{j}.pos;
            Aij = (1/norm(x_ij)^2)*(x_ij*x_ij');
            Pij = Aij*agents{i}.u_opt;
            P(c) = (1/2)*norm(Pij - m{i,j})^2;
        end
        
    end
end


end

