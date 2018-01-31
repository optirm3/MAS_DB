function [product] = prodMultiDimOPT(gains)
% A is a vector (1 x) 1 x Edges
% B is a multi matrix Edges x Edges x Edges - cell matrix of vector
% PRODUCT is a multi matrix (1 x 1 x) Edges x Edges

edges = length(gains);
product = zeros(edges,edges);
for i=1:edges
    product(i,i) = 2*gains(i);
end