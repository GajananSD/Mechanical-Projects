clear all;

r_1 = 7;
r_2 = 4;
r_3 = 8;
r_4 = 6;
t = 0:5/180:10;
ang_speed = pi/5;
theta_2 = ang_speed*t;
theta_1 = deg2rad(0);
len = length(theta_2)-1;
    
for i=1:length(theta_2)

theta_2_prime(i) = theta_2(i) - theta_1;
delta(i) = sqrt(r_1^2 + r_2^2 -2*r_1*r_2*cos(theta_2_prime(i)));
beta(i) = acos( (r_1^2 + delta(i)^2 - r_2^2) / (2*r_1*delta(i)));
psi(i) = acos( (r_3^2 + delta(i)^2 - r_4^2) / (2*r_3*delta(i)));
lambda(i) = acos( (r_4^2 + delta(i)^2 - r_3^2) / (2*r_4*delta(i)));

if(theta_2_prime<=pi)
    theta_3(i) = psi(i)-(beta(i)-theta_1);
    theta_4(i) = pi-lambda(i)-(beta(i)-theta_1);
    gamma(i)= acos( (r_3^2+r_4^2-delta(i)^2) / (2*r_3*r_4)) - pi/2;
else
    theta_3(i) = psi(i)+(beta(i)+theta_1);
    theta_4(i) = pi-lambda(i)+(beta(i)+theta_1);
    gamma(i)= acos( (r_3^2+r_4^2-delta(i)^2) / (2*r_3*r_4)) - pi/2;
end

omega_4(i) = ang_speed * (r_2*(sin(theta_3(i)-theta_2(i)))) / (r_4*(sin(theta_3(i)-theta_4(i))));
MA(i) = ( r_4*sin(theta_4(i)-theta_3(i)) )/( r_2*sin(theta_2(i)-theta_3(i)) ); %mechanical advantage

Ax(i) = r_2*cos(theta_2(i));
Ay(i) = r_2*sin(theta_2(i));
Bx(i) = r_2*cos(theta_2(i))+r_3*cos(theta_3(i));
By(i) = r_2*sin(theta_2(i))+r_3*sin(theta_3(i));
Box(i) = r_1*cos(theta_1);
Boy(i) = r_1*sin(theta_1);

plot([0 Ax(i)], [0 Ay(i)],'ro-','LineWidth',5);hold on; %r2
plot([Ax(i) Bx(i)], [Ay(i) By(i)], 'go-','LineWidth',5); hold on; %r3
plot([Bx(i) Box(i)], [By(i) Boy(i)], 'bo-','LineWidth',5); hold on; %r4
plot([Box(i) 0], [Boy(i) 0], 'co-','LineWidth',5);hold off; %r1

grid on
axis([-15 15 -5 10]);
pause(0.001);
end

subplot(2,1,1)
plot(rad2deg(theta_2),rad2deg(theta_3));
title(' Coupler angle ')
xlabel('\theta2')
ylabel('\theta3')
grid on

subplot(2,1,2)
plot(rad2deg(theta_2),rad2deg(theta_4));
title(' Rocker angle ')
xlabel('\Theta2')
ylabel('\Theta4')
grid on

