function [A]=adjancencyMatrix(x,vis)
d=dist(x');
A = ( d<vis);
A=A-eye(length(A),length(A));
end


