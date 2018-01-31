function [kopt,F,FAlg,exitflag,prova] = evaluateFGtest(MAS,iter,k0,method)

if nargin<4
    method = 1;
end

G = MAS.graphHist{iter};
edges = sum(sum(G))/2;
edge_list = zeros(edges,2);
edge_counter = 1;
gain = zeros(edges,1);
K = MAS.KHist{iter};
n = MAS.n;
m = MAS.m_ijHist{iter};
dist = MAS.distHist{iter};

for i=1:n
    for j=i:n
        if ~isempty(m{i,j})
            edge_list(edge_counter,1) = i;
            edge_list(edge_counter,2) = j;
            gain(edge_counter) = K(i,j);
            edge_counter = edge_counter + 1;
        end
    end
end

B = cell(n,1);
A_ij = cell(n,n);
AB = cell(n,n);
for i=1:n
    
    B_i = zeros(2,edges);
    for k=1:edges
        if (edge_list(k,1)==i || edge_list(k,2)==i)
            if edge_list(k,1)==i
                B_i(:,k) = m{i,edge_list(k,2)};
            else
                B_i(:,k) = m{i,edge_list(k,1)};
            end
        else
            B_i(:,k) = [0; 0];
        end
    end
    B{i} = B_i;
    
    for j=1:n
        if G(i,j)>0
            d = dist{i,j};
            A_ij_value = (d*d')/(norm(d)^2);
            A_ij{i,j} = A_ij_value;
            AB{i,j} = A_ij_value*B_i;
        end
    end
end

F = 0;
FAlg = 0;
Grad = 0;
GradAlg = 0;
N = length(m);

A = [];
b = [];
Aeq = [];
beq = [];
LB = zeros(edges,1);
UB = 10*ones(edges,1);
if nargin<3
    k0 = ones(edges,1);
end
nonlcon = [];

if method==2
    % Only Gradient
    minF = @(k)F_Function(k,m,G,AB);
    options = optimoptions('fmincon','SpecifyObjectiveGradient',true,'Display','off');%,'StepTolerance',1e-15,'PlotFcn',@optimplotfval);
elseif method==1
    % Gradient and Hessian
    minF = @(k)F_Function_Hessian(k,m,G,AB);%,gradGradGammaGain);
    H_Function = @(k,lambda)Hessian_Function(k,lambda,m,G,AB);%,gradGradGammaGain);
    options = optimoptions('fmincon','Algorithm','interior-point','Display','off',...
        'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,'HessianFcn',H_Function);%,'PlotFcn',@optimplotfval);
end

[kopt,fValue,exitflag,output,lambda,grad,hessian] = fmincon(minF,k0,A,b,Aeq,beq,LB,UB,nonlcon,options);

gammaGain = kopt.^2;
prova = 0;

for i=1:N
    for j=1:N
        
        if G(i,j)>0
            
            % Objective Function
            F = F + (1/2)*(norm(AB{i,j}*gammaGain - m{i,j})^2);
            FAlg = FAlg + (1/2)*(norm(AB{i,j}*(gain.^2) - m{i,j})^2);
            prova = prova + (1/2)*(norm(AB{i,j}*(k0.^2) - m{i,j})^2);
            
            % Gradient Required
            if nargout > 4
                Grad = Grad + (AB{i,j}*gammaGain - m{i,j})'*(AB{i,j}*2*diag(gammaGain));
                GradAlg = GradAlg + (AB{i,j}*(gain.^2) - m{i,j})'*(AB{i,j}*2*diag(gain));
            end
            
        end
        
    end
end
if nargout > 4
    G = norm(Grad);
    GAlg = norm(GradAlg);
end

