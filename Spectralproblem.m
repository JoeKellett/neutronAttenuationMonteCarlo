close all
clear all

r= 1;
n=10000;
for i=n:-1:1
theta= asin(2*rand-1)-pi/2;
phi =2*pi*rand;

x(i)= r.*sin(theta).*sin(phi);
y(i)= r.*sin(theta).*cos(phi);
z(i)= r.*cos(theta);
end

%subplot(1,2,1);
h1=plot3(x,y,z,'.');
axis equal;
set(h1, 'MarkerSize', 1)
xlabel('x')
ylabel('y')
zlabel('z')

% for i=1:n
% theta= asin(2*randssp-1)-pi/2;
% phi =2*pi*randssp;
% 
% x(i)= r.*sin(theta).*sin(phi);
% y(i)= r.*sin(theta).*cos(phi);
% z(i)= r.*cos(theta);
% end
% 
% subplot(1,2,2);
% h2=plot3(x,y,z,'r.');
% axis equal;
% set(h2, 'MarkerSize', 1)