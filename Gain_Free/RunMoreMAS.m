function [] = RunMoreMAS(n,opt,method,iterations)

data = [];

for i=1:iterations
    [~,total_time,mean_vel] = RunMAS(n,opt,method,false,false,false);
    close all
    data(:,i) = mean_vel;
end

mean_speed = mean(data,2);

f = fit(total_time,mean_speed,'exp1');
figure
plot(f,total_time,mean_speed)