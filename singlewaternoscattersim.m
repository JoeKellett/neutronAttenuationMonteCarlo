function [ proptrans, proprefl, propabs ] = singlewaternoscattersim( thickness, numparticles )
%SINGLESLABSIM Summary of this function goes here
%   Detailed explanation goes here

%Define constants
barn = 10^-24;
N_A = 6.023*10^23;

    sigma_a = 0.6652*barn;
    sigma_s = 0;
    rho = 1.0;
    M = 18;

n = rho*N_A/M;
msigma_a = n*sigma_a;
msigma_s = n*sigma_s;
msigma_total = msigma_a + msigma_s;

lambda = 1/msigma_total; %Mean free path calculated

%Set counters to 0.
numreflected = 0;
numtransmitted = 0;
numabsorbed = 0;

for n = 1:numparticles

    x(1) = 0; y(1) = 0; z(1) = 0;%Neutron initial position

    iskilled = 0;
    i = 2;

    while iskilled ==0
        [dx, dy, dz] = randomnormalstep(lambda); %First step to the normal
        
        x(i) = x(i-1) + dx; %Save steps
        y(i) = y(i-1) + dy;
        z(i) = z(i-1) + dz;
        
        
        if x(i) > thickness
            iskilled = 1;
            numtransmitted = numtransmitted + 1;
        elseif x(i) < 0
            iskilled = 1;
            numreflected = numreflected + 1;
        elseif rand < msigma_a/msigma_total
            iskilled = 1;
            numabsorbed = numabsorbed + 1;
        end
        
        i = i + 1; %Iterate i
    end
end

totalparts = numtransmitted+numreflected+numabsorbed;
proptrans = numtransmitted/totalparts;
proprefl = numreflected/totalparts;
propabs = numabsorbed/totalparts;
end