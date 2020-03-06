%Main

%This program reads an input file which represents the circuit and finds
%voltages of nodes by using node-voltage method. It prints these values 
%as output.
%The text in the input file should be like this: V1 0 1 10
%                                                R1 0 2 5
%                                                I1 0 3 2
%                                                R2 0 3 10
%                                                R3 1 2 1
%                                                R4 2 3 2

%filename = input('Enter the filename: ', 's');
cellarray = getInput('inputs.txt');
[n,x] = calcX(cellarray);
outputX(n,x);
