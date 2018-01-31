function [ result ] = takeoffRequest( agent )
%CF_LAND
%return 1 se la call è andata a buon fine
%       0 altrimenti
result = call(agent.rob_client_takeoff,agent.rob_takeoff,'Timeout',3);

end