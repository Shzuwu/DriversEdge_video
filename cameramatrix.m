function [a] = cameramatrix( A )
%Compute camera matrix
%   matrix A should be of form [x,y,u,v] for each row
n=size(A,1);
matrixrows=n*2;
a=zeros(matrixrows,9);
j=1;
for i=1:n
a(j,:)=[-A(i,1) -A(i,2) -1 0 0 0 A(i,1)*A(i,3) A(i,2)*A(i,3) A(i,3)];
a(j+1,:)=[0 0 0 -A(i,1) -A(i,2) -1 A(i,1)*A(i,4) A(i,2)*A(i,4) A(i,4)];
j=j+2;
end

end