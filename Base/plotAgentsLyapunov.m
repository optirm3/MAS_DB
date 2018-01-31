function [] = plotAgentsLyapunov(MAS)

n = MAS.n;
iter = MAS.iter-1;
dt = MAS.dt;
time = dt:dt:(dt*iter);
time_plot = zeros(n,iter);

for i=1:n
    time_plot(i,:) = time;
end

figure
title('Lyapunov')
subplot(3,1,1)
plot(time,MAS.VHist(2:end))
title('V')
subplot(3,1,2)
plot(time,MAS.V1Hist(2:end))
title('V1')
subplot(3,1,3)
plot(time,MAS.V2Hist(2:end))
title('V2')

% Lyapunov Derivative
figure
% subplot(2,1,1)
% plot(MAS.HistDPhi(2:end,1))
% title('\nabla_{dx} Phi')
% subplot(2,1,2)
% plot(MAS.HistDPhi(2:end,2))
% title('\nabla_{dk} Phi')
plot(time,MAS.HistDPhi(2:end))
title('DV')

end