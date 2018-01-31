function [gain_vector] = gainmat2vec(gain_matrix,G)

edges = sum(sum(G))/2;
gain_vector = zeros(edges,1);
gain_counter = 1;
N = length(gain_matrix);

for i=1:N
    for j=i+1:N
        gain_vector(gain_counter,1) = gain_matrix(i,j);
        gain_counter = gain_counter + 1;
    end
end

end