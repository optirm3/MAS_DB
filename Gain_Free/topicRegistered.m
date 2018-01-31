% Check if a topic is registered 
% NOTE: Useful for the setup not required for the user
function ispresent=topicRegistered(topic)

elements = rostopic('list');
string = topic;

ispresent = sum(cellfun(@(s) ~isempty(strfind(string, s)), elements)>0);


