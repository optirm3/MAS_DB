function [product] = prodMultiDim(A,B)
% A is a vector (1 x) 1 x Edges
% B is a multi matrix Edges x Edges x Edges - cell matrix of vector
% PRODUCT is a multi matrix (1 x 1 x) Edges x Edges

edges = length(A);
product = zeros(edges,edges);
for i=1:edges
    for j=1:edges
        sum = 0;
        for x=1:edges
            vector_element = B{x,i};
            sum = sum + A(x)*vector_element(j);
        end
        product(i,j) = sum;
    end
end