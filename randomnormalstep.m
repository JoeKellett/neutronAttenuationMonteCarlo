function [ x ,y ,z ] = randomnormalstep(length)
%RANDOMNORMALSTEP Produces a step perpendicular to the slab.
%   Produces a step of length exponentially distributed about the mean free
%   path. This is used as the first step in the simulations.
x= -length*log(rand); y=0 ;z=0;
end

