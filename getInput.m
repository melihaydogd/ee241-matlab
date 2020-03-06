function [carr] = getInput(filename)
%getInput This function reads the values in the input file.
%   Inputs are read by using textscan function. Therefore, the input values
%   are settled in cells.

fid = fopen(filename, 'r');
carr = textscan(fid, '%s %f  %f %f');
fclose(fid);

end

