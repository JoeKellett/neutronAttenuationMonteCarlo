function [ proptrans, proprefl, propabs ] = singleslabsim( material, thickness, numparticles )
%SINGLESLABSIM Finds proportion of neutrons transmitted etc though material
%   Uses the Monte Carlo technique simulate neutrons travelling through
%   various shielding materials

%Define constants
barn = 10^-24;
N_A = 6.023*10^23; %Avagadro's number

%Decide which values to apply for the material.
if material=='w' %Water
    sigma_a = 0.6652*barn; %Absorbtion cross sectional area
    sigma_s = 103*barn;  %Scattering cross sectional area
    rho = 1.0; %Density of water
    M = 18; %Mass of 1 mole of water.
elseif material=='a' %Water without scattering
    sigma_a = 0.6652*barn;
    sigma_s = 0; 
    rho = 1.0;
    M = 18;
elseif material=='g' %Graphite
    sigma_a = 0.0045*barn;
    sigma_s = 4.74*barn;
    rho = 1.67;
    M = 12;
elseif material=='l' %Lead
    sigma_a = 0.158*barn;
    sigma_s = 11.221*barn;
    rho = 11.35;
    M = 207;
else
    error('Input not recognised. Exiting.')
end

n = rho*N_A/M; %Number density
msigma_a = n*sigma_a;%Macroscopic cross-sectional absorption area
msigma_s = n*sigma_s;%Macroscopic cross-sectional scattering area
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
        if i == 2 || material=='a'
            [dx, dy, dz] = randomnormalstep(lambda); %First step to the normal
        else
            [dx, dy, dz] = randomstep(lambda); %Next steps random direction
        end
        
        x(i) = x(i-1) + dx; %Save steps
        y(i) = y(i-1) + dy;
        z(i) = z(i-1) + dz;
        
        if x(i) > thickness %If particle is transmitted
            iskilled = 1; %Set is killed flag.
            numtransmitted = numtransmitted+1; %Add to tally
        elseif x(i) < 0 %If particle is reflected
            iskilled = 1;
            numreflected = numreflected+1;
        elseif rand < msigma_a/msigma_total %If particle is absorbed
            iskilled = 1;
            numabsorbed = numabsorbed+1;
        end
        
        i = i + 1; %Iterate i
    end
end

totalparts = numtransmitted+numreflected+numabsorbed; %This should equal numparticles
proptrans = numtransmitted/totalparts; %Proporiton of neutrons transmitted
proprefl = numreflected/totalparts; %Proporiton of neutrons transmitted
propabs = numabsorbed/totalparts;%Proporiton of neutrons transmitted

%Plot a random walk of last neutron simulated.
% figure
% plot3(x,y,z);
% xlabel('x /cm'); ylabel('y /cm'); zlabel('z /cm')
% axis equal
end