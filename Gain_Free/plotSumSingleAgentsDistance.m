function []= plotSumSingleAgentsDistance(MAS,CF)

n = MAS.n;
iter = MAS.iter;
dt = MAS.dt;
time = dt:dt:(dt*iter);
id = find(MAS.RobIDs==CF);

pose_x = zeros(n,iter);
pose_y = zeros(n,iter);
pose_z = zeros(n,iter);
dist = zeros(1,iter);

for k=1:iter
    sum_distance = 0;
    
    for i=1:n
        pose_x(i,k) = (MAS.poseHist{k}.xyz(i,1));
        pose_y(i,k) = (MAS.poseHist{k}.xyz(i,2));
        pose_z(i,k) = (MAS.poseHist{k}.xyz(i,3));
    end
    
    for j=1:n
        if j==id
            continue
        end
        sum_distance = sum_distance + sqrt((pose_x(id,k)-pose_x(j,k))^2+(pose_y(id,k)-pose_y(j,k))^2);
    end
    
    dist(1,k) = sum_distance;
end


%% n pairs -> 1 plot

figure
title('Distance')
xlabel('Time')
ylabel('Norm')
hold on
grid on
plot(time,dist(1,:))
legend('Sum of total agents distance')