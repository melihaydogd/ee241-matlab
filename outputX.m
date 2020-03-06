function [] = outputX(n,x)
%outputX This function prints the output values which are voltages on
%nodes.
%   The voltages on nodes taken as input which is x. n is the number of 
%   nodes. By using n, the values of node voltages are determined and 
%   the outputs are printed.

for i = 1:n
        fprintf('Voltage of Node %d is %f.\n', i, x(i))
end
end

