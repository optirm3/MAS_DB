function [Fvalue,FAlgvalue,kOptHist] = plotFComparison(MAS)

figure
hold on
grid on
title('F-Value Comparison')
xlabel('Iterations')
ylabel('Value')
Fvalue = zeros(1,MAS.iter);
FAlgvalue = zeros(1,MAS.iter);
kOptHist = cell(1,MAS.iter);
k=1;
dt = MAS.dt;

for i=1:MAS.iter
    if mod(i,10)==0
        %fprintf('Iteration number %d\n',i);
        [kOpt,F,FAlg,exitflag,Fone] = evaluateFGtest(MAS,i);
        kOptHist{k} = kOpt;
        Fvalue(k) = F;
        FAlgvalue(k) = FAlg;
        if exitflag==1
            plot(i*dt,F,'dr')
        else
            plot(i*dt,F,'db')
        end
        scatter(i*dt,FAlg,'g')
        scatter(i*dt,Fone,'b')
        k = k+1;
        drawnow
    end
end