function [a] = cameracoef( x,y,u,v )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a=[-x -y -1 0 0 0 x*u y*u u; 0 0 0 -x -y -1 x*v y*v v]


end

