function []= plotAgentsDistance(MAS)

n = MAS.n;
iter = MAS.iter;
dt = MAS.dt;
time = dt:dt:(dt*iter);

pose_x = zeros(n,iter);
pose_y = zeros(n,iter);
pose_z = zeros(n,iter);
dist = zeros(n,iter);

for k=1:iter
    for i=1:n
        pose_x(i,k) = (MAS.poseHist{k}.xyz(i,1));
        pose_y(i,k) = (MAS.poseHist{k}.xyz(i,2));
        pose_z(i,k) = (MAS.poseHist{k}.xyz(i,3));
    end
    dist(1,k) = sqrt((pose_x(1,k)-pose_x(2,k))^2+(pose_y(1,k)-pose_y(2,k))^2);
    if n>=3
        dist(2,k) = sqrt((pose_x(1,k)-pose_x(3,k))^2+(pose_y(1,k)-pose_y(3,k))^2);
        dist(3,k) = sqrt((pose_x(2,k)-pose_x(3,k))^2+(pose_y(2,k)-pose_y(3,k))^2);
    end
    if n>=4
        dist(4,k) = sqrt((pose_x(1,k)-pose_x(4,k))^2+(pose_y(1,k)-pose_y(4,k))^2);
        dist(5,k) = sqrt((pose_x(2,k)-pose_x(4,k))^2+(pose_y(2,k)-pose_y(4,k))^2);
        dist(6,k) = sqrt((pose_x(3,k)-pose_x(4,k))^2+(pose_y(3,k)-pose_y(4,k))^2);
    end
    if n>=5
        dist(7,k) = sqrt((pose_x(1,k)-pose_x(5,k))^2+(pose_y(1,k)-pose_y(5,k))^2);
        dist(8,k) = sqrt((pose_x(2,k)-pose_x(5,k))^2+(pose_y(2,k)-pose_y(5,k))^2);
        dist(9,k) = sqrt((pose_x(3,k)-pose_x(5,k))^2+(pose_y(3,k)-pose_y(5,k))^2);
        dist(10,k) = sqrt((pose_x(4,k)-pose_x(5,k))^2+(pose_y(4,k)-pose_y(5,k))^2);
    end
    if n>=6
        dist(11,k) = sqrt((pose_x(1,k)-pose_x(6,k))^2+(pose_y(1,k)-pose_y(6,k))^2);
        dist(12,k) = sqrt((pose_x(2,k)-pose_x(6,k))^2+(pose_y(2,k)-pose_y(6,k))^2);
        dist(13,k) = sqrt((pose_x(3,k)-pose_x(6,k))^2+(pose_y(3,k)-pose_y(6,k))^2);
        dist(14,k) = sqrt((pose_x(4,k)-pose_x(6,k))^2+(pose_y(4,k)-pose_y(6,k))^2);
        dist(15,k) = sqrt((pose_x(5,k)-pose_x(6,k))^2+(pose_y(5,k)-pose_y(6,k))^2);
    end
end


%% n pairs -> 1 plot

figure
title('Distance')
xlabel('Time')
ylabel('Norm')
hold on
grid on
plot(time,dist(1,:))
legend('Agents 1-2')
if n>=3 
    plot(time,dist(2,:))
    plot(time,dist(3,:))
    legend('Agents 1-2','Agents 1-3','Agents 2-3')
end
if n>=4
    plot(time,dist(4,:))
    plot(time,dist(5,:))
    plot(time,dist(6,:))
    legend('Agents 1-2','Agents 1-3','Agents 2-3','Agents 1-4','Agents 2-4','Agents 3-4')
end
if n>=5
    plot(time,dist(7,:))
    plot(time,dist(8,:))
    plot(time,dist(9,:))
    plot(time,dist(10,:))
    legend('Agents 1-2','Agents 1-3','Agents 2-3','Agents 1-4','Agents 2-4','Agents 3-4',...
        'Agents 1-5','Agents 2-5','Agents 3-5','Agents 4-5')
end
if n>=6
    plot(time,dist(11,:))
    plot(time,dist(12,:))
    plot(time,dist(13,:))
    plot(time,dist(14,:))
    plot(time,dist(15,:))
    legend('Agents 1-2','Agents 1-3','Agents 2-3','Agents 1-4','Agents 2-4','Agents 3-4',...
        'Agents 1-5','Agents 2-5','Agents 3-5','Agents 4-5',...
        'Agents 1-6','Agents 2-6','Agents 3-6','Agents 4-6','Agents 5-6')
end

%% 1 pair -> 1 plot
% figure();
% plot(dist(:,1))
% if n==2
%     title('Distance')
% end
% if n>=3
%     title('Distance 1-2')
%     figure();
%     plot(dist(:,2))
%     title('Distance 1-3')
%     figure();
%     plot(dist(:,3))
%     title('Distance 2-3')
% end
% if n>=4
%     figure();
%     plot(dist(:,4))
%     title('Distance 1-4')
%     figure();
%     plot(dist(:,5))
%     title('Distance 2-4')
%     figure();
%     plot(dist(:,6))
%     title('Distance 3-4')
% end