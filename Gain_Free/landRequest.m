function [ result ] = landRequest( agent )
%CF_LAND
%return 1 se la call è andata a buon fine
%       0 altrimenti
result = call(agent.rob_client_land,agent.rob_land,'Timeout',3);

end