function [] = drawCenter(MAS,start_iteration)

if nargin<2
    start_iteration = 1;
end
if start_iteration > MAS.iter
    error('Iteration wrong');
end

graphics.h=figure();
box on;
hold on;
grid on;
n = MAS.n;
rho = MAS.rho;
if MAS.ROS
    speed_vel = true;
else
    speed_vel = false;
end
showLinks = false;
showSpeed = true;
showIDs = true;
plotRange = [-MAS.l/2 MAS.l/2 -MAS.l/2 MAS.l/2];
%axis(plotRange);
ct = start_iteration*MAS.dt;
dt = MAS.dt;

xyz = MAS.poseHist{1}.xyz;
offset = mean(xyz(:,1:MAS.d),1);
offset = [offset; offset];
offset = offset(:)';
axis_val = round(offset + plotRange);
axis(axis_val);

scalarealspeed = 15;
offset_text = 0.05;

%% Init
xyz =  MAS.poseHist{start_iteration}.xyz;
xyz_dist=dist(xyz');
if showSpeed
    vel = MAS.uOptHist{start_iteration};
    if speed_vel
        real_vel = MAS.speedHist{start_iteration}.vel_xyz*scalarealspeed;
    end
end
ct = ct + dt;
baricentro = mean(xyz);
graphics.bar = plot(baricentro(1),baricentro(2),'Marker','o','Color','m');
for i=1:n
    str=sprintf('Time: %0.2f / %0.2f',ct,MAS.t);
    title(str);
    graphics.pos(i) = plot(xyz(i,1), xyz(i,2), 'Marker', MAS.markerAgents, 'Color',MAS.colorAgents);
    if showIDs
        graphics.label(i) = text(xyz(i,1)+offset_text,xyz(i,2)+offset_text,sprintf('%d',i));
    end
    if showSpeed
        graphics.speed(i) = quiver(xyz(i,1),xyz(i,2),vel(1,i),vel(2,i),'Color','r');
        if speed_vel
            graphics.real_speed(i) = quiver(xyz(i,1),xyz(i,2),real_vel(i,1),real_vel(i,2),'Color',[0 0.4 0]);
        end
    end
    if showLinks
        for j=i+1:n
            if (xyz_dist(i,j)<rho)
                data=[xyz(i,:) ; xyz(j,:)];
                graphics.edge(i,j) = line(data(:,1),data(:,2),'Color',MAS.colorEdges,'LineStyle',MAS.lineStyleEdges);
            else
                graphics.edge(i,j) = line([0 0],[0 0],'Color',MAS.colorEdges,'LineStyle',MAS.lineStyleEdges);
            end
        end
    end
end

%% Iterations
for k=(start_iteration+1):MAS.iter
    xyz =  MAS.poseHist{k}.xyz;
    xyz_dist=dist(xyz');
    if showSpeed
        vel = MAS.uOptHist{k};
        if speed_vel
            real_vel = MAS.speedHist{k}.vel_xyz*scalarealspeed;
        end
    end
    ct = ct + dt;
    str=sprintf('Time: %0.2f / %0.2f',ct,MAS.t);
    title(str);
    
    baricentro = mean(xyz);
    set(graphics.bar,'xdata', baricentro(1), 'ydata', baricentro(2));
    
    for i=1:n
        
        set(graphics.pos(i),'xdata', xyz(i,1), 'ydata', xyz(i,2));
        if showIDs
            set(graphics.label(i),'Position',[xyz(i,1:2)+offset_text 0]);
        end
        
        if showSpeed
            set(graphics.speed(i), 'XData',xyz(i,1),'YData',xyz(i,2),'UData',vel(1,i),'VData',vel(2,i));
            if speed_vel
                set(graphics.real_speed(i), 'XData',xyz(i,1),'YData',xyz(i,2),'UData',real_vel(i,1),'VData',real_vel(i,2));
            end
        end
        if showLinks
            for j=i+1:n
                if (xyz_dist(i,j)<rho)
                    data=[xyz(i,:) ; xyz(j,:)];
                    set(graphics.edge(i,j), 'XData', data(:,1), 'YData', data(:,2));
                else
                    set(graphics.edge(i,j), 'XData', [0 0], 'YData', [0 0]);
                end
            end
        end
    end
    pause(0.01)
end

