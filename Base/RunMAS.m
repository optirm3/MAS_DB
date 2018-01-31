% Framework developed for simulating multi-agent systems
function [MAS] = RunMAS(n,ros,gazebo,RobCFs,RobSAs)

%% Basic setup
close all

% Input arguments
if nargin == 0
    error('Not enough input arguments');
elseif nargin == 1
    fprintf('ROS and Gazebo flag not selected, running in MATLAB.\n\n\n')
    ros = false;
    gazebo = false;
    RobCFs = [];
    RobSAs = [];
elseif nargin == 2
    fprintf('Gazebo flag not selected, running without it.\n\n\n')
    gazebo = false;
    if ros && isempty(RobCFs) && isempty(RobSAs)
        error('Can not run in ROS without any agents!\n\n\n');
    end
    RobCFs = [];
    RobSAs = [];
elseif nargin == 3
    fprintf('Running using ROS and Gazebo.\n\n\n');
    if lenght(RobCFs)+length(RobSAs)>0
        fprintf('Warning: using Gazebo and real agents.\n\n\n');
    end
elseif nargin == 4
    fprintf('Using only Crazyflies.')
    if ~ros
        error('If you want to use CF, you need to select ROS flag');
    end
    if length(RobCFs)~=n
        error('Number of agents and CFs do not match');
    end
    RobSAs = [];
elseif nargin == 5
    if length(RobCFs)+length(RobSAs)~=n
        error('Number of agents n and actual agents do not match.\n\n\n');
    end
elseif nargin > 5
    error('Too many input arguments.\n\n\n');
end

%% Fundamental Parameters
Parameters.n = n;                               % Number of agents
Parameters.d = 2;                               % Dimension of the simulation [It can be either 2 or 3]
Parameters.kin = 2;                             % Kinematics [0: Single Integrator; 1: Unicycle; 2: Quadrotor]
Parameters.s = 0;                               % Angular Dimension [It can be either 0, 1, 2 or 3]
Parameters.dt = 0.01;                           % Sampling time [s]
Parameters.t = 5;                               % Simulation time [s]
Parameters.l = 5;                             % Environment One Dimension Size
Parameters.rho = 20;                            % Agent's Visibility
Parameters.rho0 = 0.5;                          % Agent's Visibility
Parameters.ROS = ros;                           % ROS Interaction
Parameters.GAZEBO = gazebo;                     % Gazebo
Parameters.Aerial_HW = 'CF';                    % Select between 'CF' and 'DJI'
Parameters.RobCFs = RobCFs;                     % Aerial Agents ID
Parameters.Ground_HW = 'Saetta';                % Only 'Saetta' available now
Parameters.RobSAs = RobSAs;                     % Ground Agents ID
Parameters.robot_name = 'ardrone';              % Robot model in Gazebo

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
plotAgentsSpeed(MAS);

%% Show Distance
if n<7
    plotAgentsDistance(MAS);
end

% %% Show Lyapunov Evolution
% plotAgentsLyapunov(MAS);

%% Cleanup The Environment
myCleanupFun(MAS);

end
