function [ x,y,z ] = randomstep(length)
%RANDOMSTEP Produces a step in a random direction.
%   Produces a step of length distributed exponetially about the mean free
%   path. The direction is decided by random numbers.

r=-length*log(rand); %Length of the vector
%Direction
theta= asin(2*rand-1)-pi/2; %To prevent concentration of points at poles
phi =2*pi*rand;

%Convert to cartesian coordinates
x= r.*sin(theta).*sin(phi);
y= r.*sin(theta).*cos(phi);
z= r.*cos(theta);
end

