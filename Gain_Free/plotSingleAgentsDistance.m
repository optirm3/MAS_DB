function []= plotSingleAgentsDistance(MAS,CF)

n = MAS.n;
iter = MAS.iter;
dt = MAS.dt;
time = dt:dt:(dt*iter);
id = find(MAS.RobIDs==CF);

pose_x = zeros(n,iter);
pose_y = zeros(n,iter);
pose_z = zeros(n,iter);
dist = zeros(n-1,iter);



for k=1:iter
    j_count = 1;
    for i=1:n
        pose_x(i,k) = (MAS.poseHist{k}.xyz(i,1));
        pose_y(i,k) = (MAS.poseHist{k}.xyz(i,2));
        pose_z(i,k) = (MAS.poseHist{k}.xyz(i,3));
    end
    
    for j=1:n
        if j==id
            continue
        end
        dist(j_count,k) = sqrt((pose_x(id,k)-pose_x(j,k))^2+(pose_y(id,k)-pose_y(j,k))^2);
        j_count = j_count+1;
    end
end


%% n pairs -> 1 plot

figure
title('Distance')
xlabel('Time')
ylabel('Norm')
hold on
grid on
if n>=2
    plot(time,dist(1,:))
    legend('Agents 1-2')
end
if n>=3
    plot(time,dist(2,:))
    legend('Agents 1-2','Agents 1-3')
end
if n>=4
    plot(time,dist(3,:))
    legend('Agents 1-2','Agents 1-3','Agents 1-4')
end
if n>=5
    plot(time,dist(4,:))
    legend('Agents 1-2','Agents 1-3','Agents 1-4','Agents 1-5')
end
if n>=6
    plot(time,dist(5,:))
    legend('Agents 1-2','Agents 1-3','Agents 1-4','Agents 1-5','Agents 1-6')
end
