rosshutdown
%rosinit('http://172.16.224.169:11311', 'NodeHost', '172.16.224.1')

setenv('ROS_MASTER_URI','http://172.16.224.169:11311')
setenv('ROS_IP','172.16.224.1')
setenv('ROS_HOSTNAME','Air-di-Matteo.station')
%setenv('ROS_HOSTNAME','MacBook-Air-di-Matteo.local')
rosinit
%pause(2)
%ppp = rossubscriber('/test_prova')
%ppp.LatestMessage
chatpub = rospublisher('/chatter','std_msgs/String');
msg = rosmessage(chatpub);
msg.Data = 'test phrase';
send(chatpub,msg)