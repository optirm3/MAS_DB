function []=myCleanupFun(MAS)

 if (MAS.ROS)
    disp('Cleanup Everything')    
    stopRobots(MAS)
    disp('Shutdown ROS')
    rosshutdown
end
    
end