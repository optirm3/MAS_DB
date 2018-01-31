selected_iter = 100;

G = MAS.graphHist{selected_iter};
m = MAS.m_ijHist{selected_iter};
dist = MAS.distHist{selected_iter};
n = MAS.n;
V2 = MAS.V2Hist(selected_iter);

edges = sum(sum(G))/2;
edge_list = zeros(edges,2);
edge_counter = 1;

for i=1:n
    for j=i:n
        if ~isempty(m{i,j})
            edge_list(edge_counter,1) = i;
            edge_list(edge_counter,2) = j;
            edge_counter = edge_counter + 1;
        end
    end
end

gradGradGammaGain = cell(edges,edges);

for i=1:edges
    for j=1:edges
        temp = zeros(edges,1);
        if i==j
            temp(i) = 2;
            gradGradGammaGain{i,j} = temp;
        else
            gradGradGammaGain{i,j} = temp;
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


A = [];
b = [];
Aeq = [];
beq = [];
LB = zeros(edges,1);
UB = 10*ones(edges,1);
k0 = ones(edges,1);
nonlcon = [];

% a = 1;
% fun = @(x)xcubo(x,a);
% hfun = @(x,lambda)hessianfcn(x,lambda,a);
% x0 = [3;2;1];
% options = optimoptions('fmincon','Algorithm','interior-point',...
%     'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,...
%     'HessianFcn',hfun);
% [x,fval,exitflag,output] = fmincon(fun,x0,[],[],[],[],[0; 0; 0],[],nonlcon,options);

% With Gradient
minF = @(k)F_Function(k,m,G,AB);
options = optimoptions('fmincon','SpecifyObjectiveGradient',true,'Display','off','StepTolerance',1e-15);
gradStartTime = tic;
[kGrad,fValueGrad,exitflagGrad,outputGrad,lambdaGrad,gradGrad,hessianGrad] = fmincon(minF,k0,A,b,Aeq,beq,LB,UB,nonlcon,options);
gradEndTime = toc(gradStartTime)
norm(gradGrad)
optErrorGrad = V2-fValueGrad;

% % With Hessian and Gradient
minF_H = @(k)F_Function_Hessian(k,m,G,AB,gradGradGammaGain);
H_Function = @(k,lambda)Hessian_Function(k,lambda,m,G,AB,gradGradGammaGain);
nonlconH = [];
options = optimoptions('fmincon','Algorithm','interior-point','Display','off',...
    'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,'HessianFcn',H_Function,...
    'MaxIteration',3000,'MaxFunctionEvaluations',3000);%,'PlotFcn',@optimplotfval);

gradGradStartTime = tic;
[kGradGrad,fValueGradGrad,exitflagGradGrad,outputGradGrad,lambdaGradGrad,gradGradGrad,hessianGradGrad] = fmincon(minF_H,k0,A,b,Aeq,beq,LB,UB,nonlcon,options);
gradGradEndTime = toc(gradGradStartTime)
norm(gradGradGrad)
