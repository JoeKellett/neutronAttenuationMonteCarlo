%--------------------------------------------------------------------------
% PROJECT2REPORTSCRIPT
% Finds the attenuation length of neutrons for water, graphite and lead
% sheilding materials. Also computes the probabilities of transmission,
% absorbtion, transmission of neutrons for set lengths of sheilding
% material
% -------------------------------------------------------------------------
% Joseph Kellett
% University of Manchester
% March 2014
% -------------------------------------------------------------------------

close all; %Close all figures
clear all; %Clear all variables stored in the memory

%--------------------------------------------------------------------------
%Example of transmitted neutrons vs thickness.
%--------------------------------------------------------------------------
numpars=1000;%Number of particles per simulation
i=1;
for thickness=0:0.1:8
    thickness1(i)=thickness;
    [t(i),~,~]=singleslabsim('w',thickness,numpars);
    i=i+1;
end

subplot(1,2,1); %Make it so 1 figure has 2 graphs
hold on %Allow plotting of fit over data points
plot(thickness1,t,'r+'); %Plot data of proportion transmitted vs thickness
P=polyfit(thickness1,log(t),1); %Fit an exponential curve to the data
plot(thickness1,exp(P(2))*exp(P(1)*thickness1)) %Plot fit on data
xlabel('Thickness of water shielding /cm')
ylabel('Proportion of neutrons transmitted (t)')

subplot(1,2,2); %Second graph on the figure
hold on
plot(thickness1,log(t),'r+'); %Plot logarithmic data
plot(thickness1,P(2)+P(1)*thickness1); %Plot straight line to log data
xlabel('Thickness of water shielding /cm')
ylabel('log(t)')

%--------------------------------------------------------------------------
%Finding the attenuation lengths
%--------------------------------------------------------------------------
clearvars thickness1 t %Clear these values to stop previous data accidentally
%being included in new values.
for j= 10:-1:1 %Iterate backwards for implicit preallocation. Repeat to allow
%standard deviations to be calculated.
i=1; %Start second iterator at 1
for thickness=1.3:0.1:4 %Run 
    thickness1(i)=thickness; %Create a vector of the different thicknesses
    [t(i),~,~]=singleslabsim('w',thickness,numpars);
    i=i+1; %Iterate i
end
P=polyfit(thickness1,log(t),1);
attenlength(j)=(-1)/P(1); %Use fit to find attenuation length
end
%Find mean and standard deviation of the attenuation length and output to
%command window
fprintf('The attenuation length of water is (%f +/- %f) cm \n',mean(attenlength),std(attenlength));


clearvars thickness1 t
%Find the attenuation length for graphite
for j=10:-1:1
i=1;
for thickness=6:0.05:10
    thickness1(i)=thickness;
    [t(i),~,~]=singleslabsim('g',thickness,numpars);
    i=i+1;
end

P=polyfit(thickness1,log(t),1);
attenlength(j)=(-1)/P(1);
end
fprintf('The attenuation length of graphite is (%f +/- %f) cm \n',mean(attenlength),std(attenlength));

clearvars thickness1 t
%Find the attenuation length for lead
for j=10:-1:1
i=1;
for thickness=4:0.1:9
    thickness1(i)=thickness;
    [t(i),~,~]=singleslabsim('l',thickness,numpars);
    i=i+1;
end

P=polyfit(thickness1,log(t),1);
attenlength(j)=(-1)/P(1);
end
fprintf('The attenuation length of lead is (%f +/- %f) cm \n',mean(attenlength),std(attenlength));

%--------------------------------------------------------------------------
%Finding the probability of transmission, reflection and absorbtion for 10
%cm of different shielding materials
%--------------------------------------------------------------------------
numparss=10000;
clearvars -except numparss %Clear stored variables except numparss
%Find the probabilities for 10 cm of water.
for i=10:-1:1
    [t(i), r(i), a(i)]= singleslabsim('w',10,numparss);
end
%Calculate the mean and standard deviation of probabilities.
fprintf('The transmission probability of a neutron incident to 10cm of water is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 10cm of water is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 10cm of water is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
%Find the probabilities for 10 cm of graphite.
for i=10:-1:1
    [t(i), r(i), a(i)]= singleslabsim('g',10,numparss);
end
fprintf('The transmission probability of a neutron incident to 10cm of graphite is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 10cm of graphite is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 10cm of graphite is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
%Find the probabilities for 10 cm of lead.
for i=10:-1:1
    [t(i), r(i), a(i)]= singleslabsim('l',10,numparss);
end
fprintf('The transmission probability of a neutron incident to 10cm of lead is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 10cm of lead is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 10cm of lead is (%.5f±%.5f)  \n\n',mean(a),std(a));

%--------------------------------------------------------------------------
%Probabilities for multiple joined slabs
%--------------------------------------------------------------------------
numparss=10000;
clearvars -except numparss
%Find the probabilities for 20 cm of water.
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('w','w',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of water is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of water is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of water is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
%Find the probabilities for 10 cm of water and 10 cm of graphite together
%using the woodcock tracking method.
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('w','g',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of water/graphite is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of water/graphite is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of water/graphite is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
%Find the probabilities for 20cm of Water-Lead shielding.
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('w','l',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of water/lead is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of water/lead is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of water/lead is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
%Find the probabilities for graphite-water shielding.
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('g','w',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of graphite/water is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of graphite/water is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of graphite/water is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
%Find the probabilities for 20 cm of graphite
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('g','g',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of graphite is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of graphite is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of graphite is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('g','l',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of graphite/lead is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of graphite/lead is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of graphite/lead is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('l','w',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of lead/water is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of lead/water is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of lead/water is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('l','g',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of lead/graphite is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of lead/graphite is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of lead/graphite is (%.5f±%.5f)  \n\n',mean(a),std(a));

clearvars -except numparss
for i=10:-1:1
    [t(i), r(i), a(i)]= woodcock('l','l',numparss);
end
fprintf('The transmission probability of a neutron incident to 20cm of lead is (%.5f±%.5f)  \n',mean(t),std(t));
fprintf('The reflection probability of a neutron incident to 20cm of lead is (%.5f±%.5f)  \n',mean(r),std(r));
fprintf('The absorbtion probability of a neutron incident to 20cm of lead is (%.5f±%.5f)  \n\n',mean(a),std(a));

%--------------------------------------------------------------------------
%Production of miscellaneous graphs and figures
%--------------------------------------------------------------------------
%Create a histogram of lengths travelled in units of mean free path.
figure %Create a new figure
for i=1000000:-1:1
x(i)=-log(rand);
end
[n,x]=hist(x,20); %20 bins

bar(x,n.*100/sum(n),1,'hist'); %Normalise bars to percentages.
xlabel('Length /\lambda')
ylabel('Frequency /%')

%An illustration of random unit vectors.
figure
r= 1; %Normalise vectors to length 1
n=10000;
for i=n:-1:1
theta= asin(2*rand-1)-pi/2; %To prevent concentration of points at poles
phi =2*pi*rand;

%Convert to cartesian coordinates
x(i)= r.*sin(theta).*sin(phi);
y(i)= r.*sin(theta).*cos(phi);
z(i)= r.*cos(theta);
end
h1=plot3(x,y,z,'.'); %Plot graph and record handle.
axis equal; %Equalise the axis.
set(h1, 'MarkerSize', 1) %Reduce marker size for clarity
xlabel('x'); ylabel('y'); zlabel('z')

%Attenuation length of water in the absense of scattering to prove
%exponentiality.
numparss=10000;
for j=10:-1:1
i=1;
for thickness=0:1:70
    thickness1(i)=thickness;
    [t(i),~,~]=singleslabsim('a',thickness,numpars);
    i=i+1;
end

P=polyfit(thickness1,log(t),1);
attenlength(j)=(-1)/P(1);
end
fprintf('The attenuation length of water in the absense of scattering is (%f +/- %f) cm \n',mean(attenlength),std(attenlength));