function [u,v] = world(x,y,V)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

H=[V(1,9) V(2,9) V(3,9); V(4,9) V(5,9) V(6,9); V(7,9) V(8,9) V(9,9)];
alpha=1/((V(7,9)*x)+(V(8,9)*y)+V(9,9));
z=alpha*H*[x;y;1];
u=z(1);
v=z(2);

end

