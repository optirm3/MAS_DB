function [] = sumBaricentre(MAS)

n = MAS.n;
dt = MAS.dt;
poseRef = cell(MAS.iter,1);
for k=1:MAS.iter
    xyz = MAS.poseHist{k}.xyz(:,1:2);
    u = MAS.uOptHist{k};
    new_xyz = zeros(n,2);
    for i=1:n
        new_xyz(i,:) = xyz(i,:) + u(:,i)'*dt;
    end
    poseRef{k} = new_xyz;
    old_bar = mean(xyz);
    new_bar = mean(new_xyz);
    sum_bar = old_bar - new_bar;
    if any(norm(sum_bar)>0.000001)
        disp('sum wrong');
    end
end