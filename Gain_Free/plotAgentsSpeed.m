function [time,mean_vel,f,vel_calc] = plotAgentsSpeed(MAS,media)

if nargin<2
    media = false;
end

n = MAS.n;
iter = MAS.iter;
dt = MAS.dt;
dim = MAS.d;
shift = 2;
time = dt:dt:(dt*iter-shift*dt);
time_plot = zeros(n,iter-shift);
vel = zeros(n,iter-shift);
vel_calc = zeros(n,iter-shift);

for k=shift+1:iter
    for i=1:n
        if MAS.ROS && ~MAS.GAZEBO
            vel(i,k-shift) = norm(MAS.speedHist{k}.vel_xyz(i,1:dim));
        	vel_calc(i,k-shift) = norm(MAS.speedHist{k}.xyz(i,1:dim));
        else
            vel(i,k-shift) = norm(MAS.speedHist{k}.xyz(i,1:dim));
        end
    end
end

for i=1:n
    time_plot(i,:) = time;
end

figure;
plot(time,vel)
grid on
title('Speed')
xlabel('Time')
ylabel('Norm')
hold on
time = time';
f=0;
mean_vel = 0;
if media
    mean_vel = mean(vel)';
    plot(time,mean_vel,'--r','LineWidth',3);

    % Fit trend
    f = fit(time(2:end),mean_vel(2:end),'exp2');
end
end