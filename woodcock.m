function [ proptrans, proprefl, propabs ] = woodcock( material1, material2, numparticles )
%WOODCOCK Finds the proportion transmitted etc though 2 shielding materials
%   This is essentially the same as singleslabsim.m with the potential for
%   ficticious steps. Water in the absense of scattering is not simulated.

%Define constants
barn = 10^-24;
N_A = 6.023*10^23;

%Decide which values to apply for material 1.
if material1=='w' %Water
    sigma_a1 = 0.6652*barn;
    sigma_s1 = 103*barn; 
    rho1 = 1.0;
    M1 = 18;
elseif material1=='g' %Graphite
    sigma_a1 = 0.0045*barn;
    sigma_s1 = 4.74*barn;
    rho1 = 1.67;
    M1 = 12;
elseif material1=='l' %Lead
    sigma_a1 = 0.158*barn;
    sigma_s1 = 11.221*barn;
    rho1 = 11.35;
    M1 = 207;
else
    error('Input not recognised. Exiting.') %If user did not enter 'a', 'w'
    %, 'l' or 'g'.
end

n = rho1*N_A/M1; %Number density
msigma_a1 = n*sigma_a1; %Macroscopic cross-sectional absorption area for first material
msigma_s1 = n*sigma_s1;%Macroscopic cross-sectional scattering area for first material
msigma_total1 = msigma_a1 + msigma_s1;
lambda1 = 1/msigma_total1; %Mean free path calculated

%Decide which values to apply for material 2.
if material2=='w' %Water
    sigma_a2 = 0.6652*barn;
    sigma_s2 = 103*barn; 
    rho2 = 1.0;
    M2 = 18;
elseif material2=='g' %Graphite
    sigma_a2 = 0.0045*barn;
    sigma_s2 = 4.74*barn;
    rho2 = 1.67;
    M2 = 12;
elseif material2=='l' %Lead
    sigma_a2 = 0.158*barn;
    sigma_s2 = 11.221*barn;
    rho2 = 11.35;
    M2 = 207;
else
    error('Input not recognised. Exiting.')
end

n = rho2*N_A/M2;
msigma_a2 = n*sigma_a2;
msigma_s2 = n*sigma_s2;
msigma_total2 = msigma_a2 + msigma_s2;

lambda2 = 1/msigma_total2; %Mean free path calculate

msigmamax=max(msigma_total1, msigma_total2); %Find the largest of the 2 
%macro cross sectional areas.
if msigma_total1==msigmamax
    lambda=lambda1;
elseif msigma_total2==msigmamax
    lambda=lambda2;
end

%Set counters to 0.
numreflected = 0; numtransmitted = 0; numabsorbed = 0;

for k = 1:numparticles
    x = 0; y = 0; z = 0;%Neutron initial position and wipe old history
    iskilled = 0; %Reset killed flag for new neutron
    i = 2; %Reset iterator
    while iskilled ==0
        if i == 2
            [dx, dy, dz] = randomnormalstep(lambda); %First step to the normal
        elseif isficticious==1
            dxold=dx; dyold=dy; dzold=dz; %Save old values
            dtotal=sqrt(dx^2+dy^2+dz^2); %Length of last step
            %Create a step with a new length but same direction
            dx=(dxold/dtotal)*(-lambda*log(rand));
            dy=(dyold/dtotal)*(-lambda*log(rand));
            dz=(dzold/dtotal)*(-lambda*log(rand));
        else
            [dx, dy, dz] = randomstep(lambda); %Next steps random direction
        end
        
        isficticious=0; %Reset ficticious flag for new step.
        x(i) = x(i-1) + dx; %Save steps
        y(i) = y(i-1) + dy;
        z(i) = z(i-1) + dz;
        
        %Find where neutron is and apply correct cross sectional areas 
        if x<10 %If neutron is in the first slab
            msigma_total=msigma_total1; %Total crosssection is that of the 
            %first slab
            msigma_a = msigma_a1; %Macro absorbtion xsection is that of the 
            %first slab
        else %x>=10 %If neutron is in the second slab
            msigma_total=msigma_total2;
            msigma_a = msigma_a2;
        end
        
        
        if x(i) >= 20
            iskilled = 1;
            numtransmitted = numtransmitted + 1;
        elseif x(i) < 0
            iskilled = 1;
            numreflected = numreflected + 1;
        elseif rand < (msigmamax-msigma_total)/msigmamax
            isficticious=1;
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