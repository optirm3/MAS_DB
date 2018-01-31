function [isSDP] = HessianAnalysis(MAS, fm, dist)

isSDP = true;
K = MAS.k;
N = MAS.n;
edges = sum(sum(MAS.A))/2;
edge_list = zeros(edges,2);
gains = zeros(edges,1);
edge_counter = 1;

for i=1:N
    for j=i:N
        if ~isempty(fm{i,j})
            gains(edge_counter) = K(i,j);
            edge_list(edge_counter,1) = i;
            edge_list(edge_counter,2) = j;
            edge_counter = edge_counter + 1;
        end
    end
end

Grad = 2*diag(gains);
Gains2 = gains.^2;

% NO MORE NECESSARY
% GradGrad = cell(edges,edges);
% 
% for i=1:edges
%     for j=1:edges
%         temp = zeros(edges,1);
%         if i==j
%             temp(i) = 2;
%             GradGrad{i,j} = temp;
%         else
%             GradGrad{i,j} = temp;
%         end
%     end
% end
    
for i=1:N
    
    %B_i = cell(1,edges);
    B_i = zeros(2,edges);
    for k=1:edges
        if (edge_list(k,1)==i || edge_list(k,2)==i)
            if edge_list(k,1)==i
                %B_i{k} = fm{i,edge_list(k,2)};
                B_i(:,k) = fm{i,edge_list(k,2)};
            else
                %B_i{k} = fm{i,edge_list(k,1)};
                B_i(:,k) = fm{i,edge_list(k,1)}; 
            end
        else
            %B_i{k} = 0;
            B_i(:,k) = [0; 0];
        end
    end
    
    for j=1:N
        if(~isempty(fm{i,j}))
            d = dist{i,j};
            A_ij = (1/(d'*d))*(d*d');
            M = (B_i')*(A_ij')*A_ij*B_i;
            
            P = (Gains2')*(B_i')*(A_ij') - fm{i,j}';
            R = P*A_ij*B_i;
            % Q = prodMultiDim(R,GradGrad);
            % OPT only for this kind of Hessian
            Q = prodMultiDimOPT(R);
            
            H = (Grad')*M*Grad + Q;
            [~,p] = chol(H);
            if p>0
                if any(eig(H)<-0.0000001)
                    isSDP = false;
                    break
                end
            end
        end 
    end 
end