function []= plotAgentsPose(MAS)

n=MAS.n;
iter=MAS.iter;

pose_x=zeros(iter,n);
pose_y=zeros(iter,n);
pose_z=zeros(iter,n);
pose_roll=zeros(iter,n);
pose_pitch=zeros(iter,n);
pose_yaw=zeros(iter,n);

for k=1:iter
    for i=1:n
        pose_x(k,i) = (MAS.poseHist{k}.xyz(i,1));
        pose_y(k,i) = (MAS.poseHist{k}.xyz(i,2));
        pose_z(k,i) = (MAS.poseHist{k}.xyz(i,3));
        pose_roll(k,i) = (MAS.poseHist{k}.rpy(i,1));
        pose_pitch(k,i) = (MAS.poseHist{k}.rpy(i,2));
        pose_yaw(k,i) = (MAS.poseHist{k}.rpy(i,3));
    end
end

figure();
plot(pose_x)
title('X')
figure();
plot(pose_y)
title('Y')
figure();
plot(pose_z)
title('Z')
% figure
% subplot(2,1,1)
% plot(pose_roll)
% grid on
% title('Roll')
% legend('3','4','5','11')
% subplot(2,1,2)
% plot(pose_pitch)
% title('Pitch')
% grid on
% legend('3','4','5','11')


% hold on;
% plot(mean(pose,2),['+' c])
% disp(mean(mean(pose,2)))

end