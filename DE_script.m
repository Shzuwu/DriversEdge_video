%first read located coordinates
%(x,y) image coordinates
%(u,v) real world coordinates
%matrix entry [x y u v] for each row
 A=[788  922 71.21 -31.78;
    910  829 67.67 -23.65;
    581  632 43.04  -8.19;
   1051  715 62.08 -10.35;
   1280  610 56.42   9.72;
   1061  487 31.33  31.48;
     45  500  0      0   ;
    511  502 15.47  12.53;
    587  469  9.58  22.71;
    956  467 23.33  33.07;
   1103  452 24.79  42.88;
    389  910 63.86 -36.24;
    377  757 50.11 -26.22;
   1824  718 78.59   3.86;
    930  960 75.27 -31.98];

%compute Direct Linear Transform matrix
a=cameramatrix(A);

%function [a] = cameramatrix( A )
%Compute camera matrix
%matrix A should be of form [x,y,u,v] for each row
%n=size(A,1);
%matrixrows=n*2;
%a=zeros(matrixrows,9);
%j=1;
%for i=1:n
%a(j,:)=[-A(i,1) -A(i,2) -1 0 0 0 A(i,1)*A(i,3) A(i,2)*A(i,3) A(i,3)];
%a(j+1,:)=[0 0 0 -A(i,1) -A(i,2) -1 A(i,1)*A(i,4) A(i,2)*A(i,4) A(i,4)];
%j=j+2;
%end

%end

%find SVD to get minimizing eigenvector
[U,S,V]=svd(a);

%function to get real world coordinates for any image coordinates
%function [u,v] = world(x,y,V)
%V is eigenvector from SVD

%H=homography
%H=[V(1,9) V(2,9) V(3,9); V(4,9) V(5,9) V(6,9); V(7,9) V(8,9) V(9,9)];
%alpha=scale coefficient
%alpha=1/((V(7,9)*x)+(V(8,9)*y)+V(9,9));
%z=alpha*H*[x;y;1]; real world coordinates
%u=z(1);
%v=z(2);
%end