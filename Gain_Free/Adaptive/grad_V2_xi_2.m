function [DV2_dx] = grad_V2_xi_2(N, agents, fm, sim)

k = sim.k;
P = cell(N,N);
DD = cell(N,N);
ND = cell(N,N);
DU_dx = cell(N,1);
DP_dx = cell(N,N);
DF_dx = cell(N,N);
Dfm_dx = cell(N,N);
DA_dx_u = cell(N,N);
DV2_dx = zeros(1,2*N);



%% (u_i)^T * d/dx(A_ij) && d/dx (u_i) && d/dx (d/dx_i Vij)

for i=1:N
    
    DUi_dx = zeros(2,2*N);
    
    for j=1:N
        
        if(i==j)
            continue
        end
        
        if(~isempty(fm{i,j}))
            d = agents{i}.pos - agents{j}.pos;
            Aij = (1/norm(d)^2)*(d*d');
            % P_ij projection vector
%             P{i,j} = ((agents{i}.u'*d)/(d'*d))*d;
            P{i,j} = Aij*agents{i}.u;
            % d/dx(A_ij)*(u_i)
            DAij_dx_u = zeros(2,2*N);
            DAij_dx_u(:,(2*i-1)) = ((1/norm(d)^2)*[2*d(1), d(2); d(2), 0] -(2*d(1)/norm(d)^4)*Aij)*agents{i}.u;
            DAij_dx_u(:,(2*i)) = ((1/norm(d)^2)*[0, d(1); d(1), 2*d(2)] -(2*d(2)/norm(d)^4)*Aij)*agents{i}.u;
            DAij_dx_u(:,(2*j-1)) = -((1/norm(d)^2)*[2*d(1), d(2); d(2), 0] - (2*d(1)/norm(d)^4)*Aij)*agents{i}.u;
            DAij_dx_u(:,(2*j)) = -((1/norm(d)^2)*[0, d(1); d(1), 2*d(2)] - (2*d(2)/norm(d)^4)*Aij)*agents{i}.u;
            DA_dx_u{i,j} = DAij_dx_u;
            % d/dx (u_i)
            DUi_dx(:,(2*i-1)) = DUi_dx(:,(2*i-1)) + [k(i,j)*(-sim.a + (sim.b/norm(d)^2.5) - ((2.5*sim.b*d(1)^2)/norm(d)^4.5)); -(2.5*sim.b*k(i,j)*d(1)*d(2))/norm(d)^4.5];
            DUi_dx(:,(2*i)) = DUi_dx(:,(2*i)) + [-(2.5*sim.b*k(i,j)*d(1)*d(2))/norm(d)^4.5; k(i,j)*(-sim.a + (sim.b/norm(d)^2.5) - ((2.5*sim.b*d(2)^2)/norm(d)^4.5))];
            DUi_dx(:,(2*j-1)) = [k(i,j)*(sim.a - (sim.b/norm(d)^2.5) + ((2.5*sim.b*d(1)^2)/norm(d)^4.5)); (2.5*sim.b*k(i,j)*d(1)*d(2))/norm(d)^4.5];
            DUi_dx(:,(2*j)) = [(2.5*sim.b*k(i,j)*d(1)*d(2))/norm(d)^4.5; k(i,j)*(sim.a - (sim.b/norm(d)^2.5) + ((2.5*sim.b*d(2)^2)/norm(d)^4.5))];
            % d/dx (fmij)
            fmij_dx = zeros(2,2*N);
            fmij_dx(:,(2*i-1)) = [(-sim.a + (sim.b/norm(d)^2.5) - ((2.5*sim.b*d(1)^2)/norm(d)^4.5)); -(2.5*sim.b*d(1)*d(2))/norm(d)^4.5];
            fmij_dx(:,(2*i)) = [-(2.5*sim.b*d(1)*d(2))/norm(d)^4.5; (-sim.a + (sim.b/norm(d)^2.5) - ((2.5*sim.b*d(2)^2)/norm(d)^4.5))];
            fmij_dx(:,(2*j-1)) = [(sim.a - (sim.b/norm(d)^2.5) + ((2.5*sim.b*d(1)^2)/norm(d)^4.5)); (2.5*sim.b*d(1)*d(2))/norm(d)^4.5];
            fmij_dx(:,(2*j)) = [(2.5*sim.b*d(1)*d(2))/norm(d)^4.5; (sim.a - (sim.b/norm(d)^2.5) + ((2.5*sim.b*d(2)^2)/norm(d)^4.5))];
            Dfm_dx{i,j} = fmij_dx;
        end
        
    end
    
    DU_dx{i,1} = DUi_dx;
    
end



%% d/dx (V2)

for i=1:N
    for j=1:N
        
        if(i==j)
            continue
        end
        
        if(~isempty(fm{i,j}))
            d = agents{i}.pos - agents{j}.pos;
            Aij = (1/norm(d)^2)*(d*d');
            DP_dx{i,j} = DA_dx_u{i,j} + Aij*DU_dx{i,1}; % d/dx (P_ij(u_i)) = d/dx(A_ij)*u_i + A_ij * d/dx (u_i)
            DF_dx{i,j} = DP_dx{i,j} - Dfm_dx{i,j}; % d/dx (P_ij(u_i) - fm_ij)
            DV2_dx = DV2_dx + (P{i,j} - fm{i,j})'*DF_dx{i,j};
        end
        
    end
end



end


