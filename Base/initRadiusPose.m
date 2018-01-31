function xyz = initRadiusPose(N,radius)

theta = 0:(2*pi/N):(2*pi-2*pi/N);

x = radius*cos(theta);
y = radius*sin(theta);
z = zeros(1,N);

xyz = [x' y' z'];

end