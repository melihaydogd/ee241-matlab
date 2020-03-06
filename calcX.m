function [n,x] = calcX(carr)
%calcX This function creates an A matrix and a z matrix by using the input
%values in the cells and find x. Ax = z => x = A^-1 * z.
%   First, the number of nodes is found and it is maximum of the third
%   column. The reason of this is that the nodes in the third columns is
%   greater than the second column.
%   Second, the number of voltage sources, resistors and current sources is
%   found to create matrices for each of them separately to make 
%   calculations easier.
%   Third, 5 matrices is created and these are G, B, C, D and z. G, B, C
%   and D are used to create the matrix of A. => A = [G B; C D].
%   At the end, the equation A * x = z is solved.
%   The explanations are made on each step.

%Determining number of nodes
n = max(carr{3});

%Determining number of voltage sources, resistors and current sources
%   According to first letters in the first column in the cell array, the 
%   number of components are determined.
m = 0;
k = 0;
t = 0;
for i = 1:length(carr{1})
    if carr{1}{i}(1) == 'V'
        m = m + 1;
    end
    if carr{1}{i}(1) == 'R'
        k = k + 1;
    end
    if carr{1}{i}(1) == 'I'
        t = t + 1;
    end
end

%A matrix for Current Sources, Voltage Sources and Resistors
%   According to first letters of the first column in the cell array and
%   the variables m,k,t, a matrix for current sources, voltage sources and 
%   resistors is created separately. A zero matrix is always created for 
%   each of them in order not to get an error message because of the 
%   existence of an empty matrix.
current = zeros(1,3);
if t ~= 0
current = zeros(t,3);
    a = 1;
    for i = 1:length(carr{1})
        if carr{1}{i}(1) == 'I' 
            current(a,:) = [carr{2}(i) carr{3}(i) carr{4}(i)];
            a = a + 1;
        end
    end
end

V = zeros(1,3);
if m ~= 0
V = zeros(m,3);
    a = 1;
    for i = 1:length(carr{1})
        if carr{1}{i}(1) == 'V'
            V(a,:) = [carr{2}(i) carr{3}(i) carr{4}(i)];
            a = a + 1;
        end
    end
end

R = zeros(1,3);
if k ~= 0
R = zeros(k,3);
    a = 1;
    for i = 1:length(carr{1})
        if carr{1}{i}(1) == 'R'
            R(a,:) = [carr{2}(i) carr{3}(i) carr{4}(i)];
            a = a + 1;
        end
    end
end

%Creating G matrix
%   This matrix is used for resistances. At the diagonal of the matrix, the
%   inverses of resistances which are connected to the a specific node is 
%   summed up. At the other parts of the matrix, the negative inverses of
%   resistances which are between the two nodes are summed up.
G = zeros(n,n);
for i = 1:n
    for j = 1:n
        if i == j
            b = [find(i == R(:,1))' find(i == R(:,2))'];
            c = sum(1./R(b,3));
            G(i,j) = c;           
        else
            for y = 1:k
                if i == R(y,1) && j == R(y,2)
                    G(i,j) = -1/R(y,3) + G(i,j);
                    G(j,i) = -1/R(y,3) + G(j,i);
                end
            end
        end
    end
end

%Creating B matrix
%   This matrix is used to understand the direction of voltage sources. If
%   the voltage is positive, the voltage of the node at the second column
%   of the V matrix is greater than the first column of the V matrix.
%   Therefore, the node at the second column takes 1 and the other node
%   takes -1. If there is no voltage sources, there is no need for this
%   matrix.
if m ~= 0
    B = zeros(n,m);
    for i = 1:n
        for j = 1:m
            if V(j,3) > 0
                if V(j,1) ~= 0 
                    B(V(j,1),j) = -1;
                end
                if V(j,2) ~= 0
                    B(V(j,2),j) = 1;
                end
            end
            if V(j,3) < 0
                if V(j,1) ~= 0 
                    B(V(j,1),j) = 1;
                end
                if V(j,2) ~= 0
                    B(V(j,2),j) = -1;
                end
            end
        end
    end
end

%Creating C and D matrix
%   These matrices are used for dependent sources. If there is no voltage
%   source, there is no need for these two matrices.
if m ~= 0
    C = B';
    D = zeros(m,m);
end

%Creating z matrix. z = [i ; e]
%   i matrix is created for determining the currents which are provided by 
%   current sources. If the current value is positive, it means the current
%   is entering the node which is the second column of the "current" 
%   matrix.
%   e matrix is created to get the voltages of the sources. The direction
%   of voltages is determined in the B matrix. If there is no voltage
%   sources there is no need for z matrix.
i = zeros(n,1);
[r,c] = size(current);
for p = 1:r
      if current(p,1) ~= 0
        i(current(p,1),1) = -current(p,3) + i(current(p,1),1);
      end
      if current(p,2) ~= 0
        i(current(p,2),1) = current(p,3) + i(current(p,2),1);
      end   
end

if m ~= 0
    e = zeros(m,1);
    for p = 1:m
        e(p,1) = V(p,3);
    end
    z = [i;e];
end
if m == 0
    z = i;
end

%Creating A matrix
%   If there is no voltage sources, the matrix of A is equal to G matrix.
if m ~= 0
    A = [G B; C D];
else
    A = G;
end

%Finding x matrix
x = A^-1 * z;

end

