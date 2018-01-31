function [MAS] = initFramework(Parameters)

%% Simulation Variables
MAS.n = Parameters.n;                            % Number of Agents
MAS.d = Parameters.d;                            % Euclidean Space Dimension
MAS.s = Parameters.s;                            % Angular
MAS.kin = Parameters.kin;                        % Agent's Kinematic [0: single integrator; 1: unicycle; 2: quadrotor]
MAS.dt = Parameters.dt;                          % Sampling Time
MAS.t = Parameters.t;                            % Total Time
MAS.ct = 0;                                      % Current Time
MAS.l = Parameters.l;                            % Environment Size
MAS.rho = Parameters.rho;                        % Visibility
MAS.rho0 = Parameters.rho0;
MAS.eta = 0;                                     % Physical Occupancy [Not Implemented Yet]
MAS.robot_name = Parameters.robot_name;          % Drone type
MAS.ROS_MASTER_URI = Parameters.ROS_MASTER_URI;
MAS.ROS_HOSTNAME = Parameters.ROS_HOSTNAME;
MAS.ROS_IP = Parameters.ROS_IP;
MAS.ROS = Parameters.ROS;
MAS.GAZEBO = Parameters.GAZEBO;
MAS.HW = Parameters.HW;
MAS.opt = Parameters.opt;
MAS.RobIDs = Parameters.RobIDs;
MAS.poseHist = [];
MAS.speedHist = [];
MAS.KHist = [];
MAS.uOptHist = [];
MAS.graphHist = [];
MAS.m_ijHist = [];
MAS.distHist = [];
MAS.iter = 0;
MAS.HessianAnalysis = false;

MAS.k = ones(MAS.n);
MAS.k_current = ones(MAS.n);
MAS.u_opt = zeros(2,MAS.n);
MAS.V1Hist = [];
MAS.V2Hist = [];
MAS.VHist = [];
MAS.DV1_dx_Hist = [];
MAS.DV1_dk_Hist = [];
MAS.DV2_dx_Hist = [];
MAS.DV2_dk_Hist = [];

MAS.method = Parameters.method;

%% Simulation data
if MAS.ROS
    if MAS.GAZEBO
        alpha = 3.0;
    else
        alpha = 1.7;
    end
else
    alpha = 1;
end
if (MAS.ROS && ~MAS.GAZEBO)
    MAS.a = alpha*0.6;
    MAS.b = alpha*1; % vedere con 0.85
else
    MAS.a = alpha*0.2;
    MAS.b = alpha*0.2;
%     MAS.a = alpha*0.15;
%     MAS.b = alpha*1.2;
end
MAS.kdt = 0.00005;
MAS.SMOOTH_EQUILIBRIUM = false;
MAS.k_iter = 1;

%% Graphics Variables
% Visibility
if (MAS.ROS)
    MAS.showGraphics =  false;
else
    MAS.showGraphics =  true & Parameters.showGraphics;
end
MAS.showAgents =  true;
MAS.showSpeed = true;
MAS.showLinks =  false;
MAS.showRadius =  false;
MAS.centerOfGravity = false;
MAS.showIDs = true;
MAS.offset_text = 0.05;

% Grahics Properties
if MAS.d == 2
    MAS.plotRange = [-MAS.l MAS.l -MAS.l MAS.l];
else
    MAS.plotRange = [-5 5 -5 5 -5 5];
end
MAS.markerAgents='o';
MAS.colorAgents='r';
MAS.lineStyleEdges = '-';
MAS.lineWidthEdges = '.5';
MAS.colorEdges = 'b';
MAS.lineStyleRadius = '--';
MAS.widthRadius = '.5';
MAS.colorRadius = 'k';


%% ROS Data Structure
if (MAS.ROS)
    MAS = initROS(MAS);
else
    MAS = initMATLAB(MAS);
end

end