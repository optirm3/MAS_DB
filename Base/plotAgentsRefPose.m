function []= plotAgentsRefPose(MAS,c)

n=MAS.n;
iter=MAS.iter;

pose_x=zeros(iter,n);
pose_y=zeros(iter,n);
pose_z=zeros(iter,n);

for k=1:iter
    for i=1:n
        pose_x(k,i) = (MAS.refPoseHist{k}.xyz(i,1));
        pose_y(k,i) = (MAS.refPoseHist{k}.xyz(i,2));
        pose_z(k,i) = (MAS.refPoseHist{k}.xyz(i,3));
        
    end
end

figure();
plot(pose_x)
title('REF X')

figure();
plot(pose_y)
title('REF Y')

% figure();
% plot(pose_z)

% hold on;
% plot(mean(pose,2),['+' c])
% disp(mean(mean(pose,2)))

end