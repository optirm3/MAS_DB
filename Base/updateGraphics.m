function [MAS]=updateGraphics(MAS,iter)%, lam2)


%% Local Variables
n = MAS.n;
d = MAS.d;
xyz = MAS.pose.xyz;
xyz_dist=dist(xyz');
vel = MAS.u;
l = MAS.l;
rho = MAS.rho;
offset_text = MAS.offset_text;

if (MAS.showGraphics)
    %% Data
    graphics = MAS.graphics;
    figure(graphics.h);
    
    %% Centering the plot
    %     offset = mean(xyz(:,1:d),1);
    %     offset = [offset; offset];
    %     offset = offset(:)';
    %     axis_val = round(offset + MAS.plotRange);
    if mod(MAS.iter,100)==0
        minxy = min(xyz(:,1:d));
        maxxy = max(xyz(:,1:d));
        axis_val = [minxy(1) maxxy(1) minxy(2) maxxy(2)]+MAS.plotRange/10;
        axis(axis_val);
    end
    
    %% Re-Drawing
    for i=1:n
        
        % Show Agents
        if (MAS.showAgents)
            if (d==3)
                set(graphics.pos(i),'xdata', xyz(i,1), 'ydata', xyz(i,2), 'zdata', xyz(i,3));
            else
                set(graphics.pos(i),'xdata', xyz(i,1), 'ydata', xyz(i,2));
            end
            
            % Show agent's IDs
            if (MAS.showIDs)
                set(graphics.label(i),'Position',[xyz(i,1:2)+offset_text 0]);
            end
            
            % Show agent's Speed
            if (MAS.showSpeed)
                set(graphics.speed(i), 'XData',xyz(i,1),'YData',xyz(i,2),'UData',vel(1,i),'VData',vel(2,i));
            end
            
            % Show agent's Radius
            if(MAS.showRadius)
                % Define a circle around the robot location [To be implemented yet!]
                if (d==3)
                    % Generate the x, y, and z data for the sphere
                    r = rho * ones(20, 20);             % radius is rho
                    [th, phi] = meshgrid(linspace(0, 2*pi, 20), linspace(-pi, pi, 20));
                    [x,y,z] = sph2cart(th, phi, r);
                    x = x + xyz(i,1);                   % center at pos(i,1) in x-direction
                    y = y + xyz(i,2);                   % center at pos(i,2) in y-direction
                    z = z + xyz(i,3);                   % center at pos(i,3) in z-direction
                    set(graphics.surface(i),'xdata', x, 'ydata', y, 'zdata', z);
                else
                    % Define a circle around the robot location [To be implemented yet!]
                    posR = [xyz(i,1:d)-rho 2*[rho rho]];
                    set(graphics.rho(i),'Position',posR);
                end
            end
            
            
            % Show Links
            if (MAS.showLinks)
                
                for j=i+1:n
                    
                    if (d==3)
                        if (xyz_dist(i,j)<rho)
                            
                            data=[xyz(i,:) ; xyz(j,:)];
                            set(graphics.edge(i,j), 'XData', data(:,1), 'YData', data(:,2), 'Zdata', data(:,3));
                        else
                            set(graphics.edge(i,j), 'XData', [0 0], 'YData', [0 0], 'Zdata', [0 0]);
                        end
                    else
                        if (xyz_dist(i,j)<rho)
                            data=[xyz(i,:) ; xyz(j,:)];
                            set(graphics.edge(i,j), 'XData', data(:,1), 'YData', data(:,2));
                        else
                            set(graphics.edge(i,j), 'XData', [0 0], 'YData', [0 0]);
                        end
                    end
                    
                end
            end
            
        end
        
    end
    
    % Shows agents' barycenter
    if (MAS.centerOfGravity)
        barycenter = mean(xyz);
        set(graphics.bar,'xdata', barycenter(1), 'ydata', barycenter(2));
    end
    
    %% Update Title
    str=sprintf('Time: %0.2f / %0.2f',MAS.ct,MAS.t);
    title(str);
    
    %% Store Graphics
    MAS.graphics=graphics;
    
    %% Draw Graphics
    drawnow
end

end
