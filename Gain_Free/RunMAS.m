% Framework developed for simulating multi-agent systems
function [MAS,total_time,mean_vel,f] = RunMAS(n,opt,method,ros,gazebo,RobIDs,showGraphics)

%% Basic setup
close all

% Input arguments
if nargin == 0
    error('%s\n%s','Declare the number of agents, the optimization flag and the method you want to use:',...
    '1 for the classical one, 2 for the adaptiveKSquared and 3 for the AdaptiveKAbs');
elseif nargin == 1
    fprintf('Method and flag not declared, running the AdapativeKSquared version with optimization enabled.\n\n\n')
    method = 2;
    opt = true;
    ros = false;
    gazebo = false;
    RobIDs = [];
    showGraphics = true;
elseif nargin == 2
    fprintf('Method not declared, running the AdapativeKSquared version.\n\n\n')
    method = 2;
    ros = false;
    gazebo = false;
    RobIDs = [];
    showGraphics = true;
elseif nargin == 3
    fprintf('Running in Matlab without ROS and Gazebo.\n\n\n');
    ros = false;
    gazebo = false;
    RobIDs = [];
    showGraphics = true;
elseif nargin == 4
    error('Declare which agents you want to use');
elseif nargin == 5
    if islogical(gazebo)
        fprintf('Running using ROS and Gazebo.\n\n\n');
        showGraphics = false;
        RobIDs = [];
    else
        error('5th argument is gazebo flag, 6th RobIDs');
    end
elseif nargin == 6
    if gazebo
        error('Flag gazebo is true but you intented to use physical agents.');
    else
        if length(RobIDs)~=n
            error('Agents and n do not match.');
        end
        showGraphics = false;
    end
elseif nargin > 7
    error('Check code');
end


% Suppress rmpath warning
warning('off','MATLAB:rmpath:DirNotFound');
% Remove old path and add new one
if method == 1
    rmpath('AdaptiveKSquared')
    rmpath('AdaptiveKAbs')
    addpath('Adaptive')
elseif method == 2
    rmpath('Adaptive')
    rmpath('AdaptiveKAbs')
    addpath('AdaptiveKSquared')
elseif method == 3
    rmpath('Adaptive')
    rmpath('AdaptiveKSquared')
    addpath('AdaptiveKAbs')
else
    error('Invalid method selected. Select 1 for classic, 2 for KSquared and 3 for KAbs');
end

%% Fundamental Parameters
Parameters.n = n;                               % Number of agents
Parameters.d = 2;                               % Dimension of the simulation [It can be either 2 or 3]
Parameters.kin = 2;                             % Kinematics [0: Single Integrator; 1: Unicycle; 2: Quadrotor]
Parameters.s = 0;                               % Angular Dimension [It can be either 0, 1, 2 or 3]
Parameters.dt = 0.01;                           % Sampling time [s]
Parameters.t = 5;                              % Simulation time [s]
Parameters.l = 5;                              % Environment One Dimension Size
Parameters.opt = opt;                           % Optimization flag
Parameters.rho = 20;                             % Agent's Visibility
Parameters.rho0 = 0.5;                          % Agent's Visibility
Parameters.ROS = ros;                           % ROS Interaction
Parameters.GAZEBO = gazebo;                     % Gazebo
Parameters.HW = 'CF';                           % Select between 'CF' and 'DJI'
Parameters.robot_name = 'ardrone';              % Robot model
Parameters.method = method;                     % Choosen method
Parameters.RobIDs = RobIDs;                     % Agents ID
Parameters.showGraphics = showGraphics;         % Visibility

%% Init Matlab for ROS
% Ros Hostname
% To get your hostname run 'hostname' on terminal/cmd
Parameters.ROS_HOSTNAME = 'DESKTOP-VMP0EHV';         % Hostname
Parameters.ROS_IP = '192.168.11.1';                  % Hostname address
% Parameters.ROS_HOSTNAME = 'Andreas-MBP';

% ROS Master Node
% a. Detect the ip of the virtual machine (ifconfig eth0 from terminal)
% b. Add the following line at the end of the file etc/hosts
%    192.168.127.XXX	ROS-INDIGO
%
%    I.     Linux/Mac:  /etc/hosts
%    II.    Windows:    C:\Windows\System32\drivers\etc\hosts
% Both machine should now be able to ping each other
Parameters.ROS_MASTER_URI = 'http://192.168.11.2:11311';          % Virtual Machine Address

%% MAF Data Structure Setting
MAS = initFramework(Parameters);

%% Cleanup Function as Callback [for ctrl+c]
finishup = onCleanup(@() myCleanupFun(MAS));

%% Initialize Graphics
MAS = initGraphics(MAS);

%% Perfor Simulation
MAS = simMAS(MAS);

%% Clean Graphics [Not Implemented Yet]
cleanGraphics(MAS);

%% Show Speed
[total_time,mean_vel,f] = plotAgentsSpeed(MAS);

%% Show Distance
if n<5
    plotAgentsDistance(MAS);
end

%% Show Lyapunov Evolution
plotAgentsLyapunov(MAS);

%% Cleanup The Environment
myCleanupFun(MAS);

end
