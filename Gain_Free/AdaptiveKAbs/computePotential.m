function [Vij]=computePotential(a, b, nrij)

   Vij=(1/2)*a*nrij^2 + 2*b*(1/nrij^(1/2));
   
end