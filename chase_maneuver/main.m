%% ORBITAL MANEUVERS USING LAMBERT'S PROBLEM 

clear;

%% CONSTANTS

%Gravitational parameter of the earth 
global mu
mu = 398600; %km^3/s^2
%Conversion factor between degrees and radians
deg = pi/180;


%% USER INPUTS 

fprintf('\n < Chase maneuvers >\n');
fprintf('\n < Inputs >\n');

% %Request orbital elements of initial orbit
% [a1, e1, incl1, RA1, w1, TA1] = user_inputs(1);
% 
% % Request orbital elements of the final orbit
% [a2, e2, incl2, RA2, w2, TA2] = user_inputs(2);

a1=  +8.34742816115028e+03 ; e1=+1.15160436236070e-01   ; incl1= +3.89462110348069e+01  ;
RA1 = +3.84863048524422e+01 ; w1=+7.77994574179083e+01 ; TA1 =+1.47304428646192e+02 ;

a2 =  +1.26500000000000e+04 ; e2=  +2.21100000000000e-01  ; incl2=+8.37091338686133e+01  ; 
RA2=  +9.27045712521672e+01  ; w2 = +1.10580854460249e+02 ; TA2 =  +1.11096516475867e+02 ;

%Request transfer direction 
fprintf('\n\nChoose the orbital direction\n');
fprintf('\n  1 - posigrade\n');
fprintf('\n  2 - retrograde');
fprintf('\n\n Select 1 or 2\n');
while(1)
    direction = input('?');
    if (direction == 1 || direction == 2)
        break;
    end
end
if direction == 1
    string = 'pro';
elseif direction == 2
    string = 'retro';
end
    
%Request time
fprintf('\n\nInput the transfer time in seconds\n')
fprintf('(transfer time > 0)\n');
while(1)
    delta_t = input('?');
    if delta_t > 0
        break;
    end
end

%% COMPUTATION OF MISSION PARAMETERS 

h1 = sqrt(a1*mu*(1-e1^2));
h2 = sqrt(a2*mu*(1-e2^2));

oe1 = [h1, e1, RA1*deg, incl1*deg, w1*deg, TA1*deg];
oe2 = [h2, e2, RA2*deg, incl2*deg, w2*deg, TA2*deg];
%Determine the state vectors of the space vehicles
[r1, v1] = sv_from_oe(oe1, mu);
[r2, v2] = sv_from_oe(oe2, mu);
%Orbital periods
T1 = 2*pi/mu^2*(h1/sqrt(1-e1^2))^3;
T2 = 2*pi/mu^2*(h2/sqrt(1-e2^2))^3;
%Determine the true anomaly of space vehicle 2 at poistion 2'
if sqrt((1-e2)/(1+e2))*tan(TA2*deg/2) < 0
    E2 = 2*(pi+atan(sqrt((1-e2)/(1+e2))*tan(TA2*deg/2)));
else
    E2 = 2*atan(sqrt((1-e2)/(1+e2))*tan(TA2*deg/2));
end
t2 = T2/(2*pi)*(E2-e2*sin(E2));
t2_prime = t2 +delta_t;
Me_2_prime = 2*pi*t2_prime/T2;
E2_prime = kepler_equation(e2, Me_2_prime);
if sqrt((1+e2)/(1-e2))*tan(E2_prime/2) < 0
    TA2_prime = 2*(pi+atan(sqrt((1+e2)/(1-e2))*tan(E2_prime/2)));%rad
else
    TA2_prime = 2*atan(sqrt((1+e2)/(1-e2))*tan(E2_prime/2));%rad
end

% orbital elements and state vector at position 2'
oe2_prime = [h2, e2, RA2*deg, incl2*deg, w2*deg, TA2_prime];
[r2_prime, v2_prime] = sv_from_oe(oe2_prime, mu);

[v1_2, v2_prime_2] = Lambert(r1, r2_prime, delta_t, string);
delta_v1 = v1_2 - v1;
delta_v2_prime = v2_prime - v2_prime_2;
% delta_v norms
delta_v = norm(delta_v1) + norm(delta_v2_prime); 
delta_v1_1 =  norm(delta_v1);

% orbital elements of the transfer orbit after the first impulse
orbital_elements = oe_from_sv(r1,v1_2,mu);
h3 = orbital_elements(1);
e3 = orbital_elements(2);
RA3 = orbital_elements(3);
incl3 = orbital_elements(4);
w3 = orbital_elements(5);
TA3 = orbital_elements(6);
a3 = orbital_elements(7);

T3 = 2*pi/mu^2*(h3/sqrt(1-e3^2))^3;

%TA at rendezvous
orbital_elements_rendezvous = oe_from_sv(r2_prime,v2_prime_2,mu);
TA3_prime = orbital_elements_rendezvous(6);

%% OUTPUTS

fprintf('\n< Results >\n');

fprintf('\nOrbital elements of the initial orbit\n');
fprintf('-------------------------------------');
fprintf ('\n        sma (km)              eccentricity          inclination (deg)         argper (deg)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', a1, e1, incl1, w1);
fprintf ('\n       raan (deg)          true anomaly (deg)       period (min)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', RA1, TA1, T1);

fprintf('\n\nOrbital elements of the transfer orbit after the first impulse\n');
fprintf('---------------------------------------------------------------');
fprintf ('\n        sma (km)              eccentricity          inclination (deg)         argper (deg)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', a3, e3, incl3/deg, w3/deg);
fprintf ('\n       raan (deg)          true anomaly (deg)       period (min)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', RA3/deg, TA3/deg, T3);

fprintf('\n\nOrbital elements of the transfer orbit prior to the final impulse\n');
fprintf('------------------------------------------------------------------');
fprintf ('\n        sma (km)              eccentricity          inclination (deg)         argper (deg)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', a3, e3, incl3/deg, w3/deg);
fprintf ('\n       raan (deg)          true anomaly (deg)       period (min)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', RA3/deg, TA3_prime/deg, T3);


fprintf('\n\nOrbital elements of the final orbit\n');
fprintf('-----------------------------------');
fprintf ('\n        sma (km)              eccentricity          inclination (deg)         argper (deg)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', a2, e2, incl2, w2);
fprintf ('\n       raan (deg)          true anomaly (deg)       period (min)');
fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', RA2, TA2, T2);

fprintf('\n\nInitial delta-v vector and magnitude\n');
fprintf('\nx-component of delta-v      %12.6f  m/s', 1000.0 * delta_v1(1));
fprintf('\ny-component of delta-v      %12.6f  m/s', 1000.0 * delta_v1(2));
fprintf('\nz-component of delta-v      %12.6f  m/s', 1000.0 * delta_v1(3));
fprintf('\n\ndelta-v magnitude           %12.6f  m/s', 1000.0 * norm(delta_v1));

fprintf('\n\nFinal delta-v vector and magnitude\n');
fprintf('\nx-component of delta-v      %12.6f  m/s', 1000.0 * delta_v2_prime(1));
fprintf('\ny-component of delta-v      %12.6f  m/s', 1000.0 * delta_v2_prime(2));
fprintf('\nz-component of delta-v      %12.6f  m/s', 1000.0 * delta_v2_prime(3));
fprintf('\n\ndelta-v magnitude           %12.6f  m/s', 1000.0 * norm(delta_v2_prime));

fprintf('\n\nTotal delta-v               %12.6f  m/s\n', 1000.0 * (norm(delta_v1) + norm(delta_v2_prime)));

fprintf('\n\nTransfer time               %12.6f  seconds \n\n', delta_t);


%% 3D GRAPHICAL REPRESENTATION  

figure
oea = zeros(360,6);
oeb = zeros(360,6);
oec = zeros(360,6);

ra = zeros(360,3);va = zeros(360,3);
rb = zeros(360,3);vb = zeros(360,3);
rc = zeros(360,3);vc = zeros(360,3);
n=1;
rxa = zeros(360,1);rya = zeros(360,1);rza = zeros(360,1);
rxb = zeros(360,1);ryb = zeros(360,1);rzb = zeros(360,1);
rxc = zeros(360,1);ryc = zeros(360,1);rzc = zeros(360,1);
%Rotate the transfer trajectory to the correct position 
%in the case when both inlinations are 0
rot = TA3/deg-TA1;
v_h = cross(r1,v1_2);
u_h = v_h/h3;
Q = [cosd(rot)+u_h(1)^2*(1-cosd(rot)) u_h(1)*u_h(2)*(1-cosd(rot))- ...
     u_h(3)*sind(rot) u_h(1)*u_h(3)*(1-cosd(rot))+u_h(2)*sind(rot);...
     u_h(2)*u_h(1)*(1-cosd(rot))+u_h(3)*sind(rot) cosd(rot)+u_h(2)^2*...
     (1-cosd(rot)) u_h(2)*u_h(3)*(1-cosd(rot))-u_h(1)*sind(rot);...
     u_h(3)*u_h(1)*(1-cosd(rot))-u_h(2)*sind(rot) u_h(3)*u_h(2)*...
     (1-cosd(rot))+u_h(1)*sind(rot) cosd(rot)+u_h(3)^2*(1-cosd(rot))];
 
 for i = 1:360
    oea(i,:)=[h1, e1, RA1*deg, incl1*deg, w1*deg, (TA1+i)*deg];
    oeb(i,:)=[h2, e2, RA2*deg, incl2*deg, w2*deg, (TA2+i)*deg];
    oec(i,:)=[h3, e3, RA3, incl3, w3, TA3+i*deg];
    [ra(i,:), va(i,:)] = sv_from_oe(oea(i,:), mu);
    [rb(i,:), vb(i,:)] = sv_from_oe(oeb(i,:), mu);
    [rc(i,:), vc(i,:)] = sv_from_oe(oec(i,:), mu);
    
    if incl1 == 0 || incl2 == 0
        rc = rc*Q;
    end
    
    rxa(n) = ra(i,1);
    rya(n) = ra(i,2);
    rza(n) = ra(i,3);
    
    rxb(n) = rb(i,1);
    ryb(n) = rb(i,2);
    rzb(n) = rb(i,3);
    
    rxc(n) = rc(i,1);
    ryc(n) = rc(i,2);
    rzc(n) = rc(i,3);
    n = n+1;
 end
 
rxc1 = rxc(1);
ryc1 = ryc(1);
rzc1 = rzc(1);

colordef black;
hold on
%initial orbit
plot3(rxa,rya,rza,'-r','LineWidth', 1.5);
%final orbit
plot3(rxb,ryb,rzb,'-g','LineWidth', 1.5);
%transfer orbit
if TA3 > TA3_prime
    b = (floor(TA3_prime/deg)+(360-floor(TA3/deg)));
else
    b = floor(TA3_prime/deg - TA3/deg);
end
plot3(rxc(1:b),ryc(1:b),rzc(1:b),'-b','LineWidth', 1.5);
plot3(rxc(b:end),ryc(b:end),rzc(b:end),'--b','LineWidth', 1.5);
%intial and rendezvous positions
plot3(r1(1),r1(2),r1(3),'ob', 'MarkerSize',8,'MarkerFaceColor','c');
plot3(r2(1),r2(2),r2(3),'ob', 'MarkerSize',8,'MarkerFaceColor','b');
plot3(r2_prime(1),r2_prime(2),r2_prime(3),'or', ...
    'MarkerSize',8,'MarkerFaceColor','r');

% plot earth
R = 6372;
% create axes
xaxisx = [1 R*2];
xaxisy = [0 0];
xaxisz = [0 0];

yaxisx = [0 0];
yaxisy = [1 R*2];
yaxisz = [0 0];

zaxisx = [0 0];
zaxisy = [0 0];
zaxisz = [1 R*2];

% plot coordinate system axes
plot3(xaxisx, xaxisy, xaxisz, '-g', 'LineWidth', 1);
plot3(yaxisx, yaxisy, yaxisz, '-r', 'LineWidth', 1);
plot3(zaxisx, zaxisy, zaxisz, '-b', 'LineWidth', 1);

[x, y, z] = sphere(24);
h = surf(R*x, R*y, R*z);
colormap([127/255 1 222/255]);
set (h, 'edgecolor', [1 1 1]);

xlabel('X coordinate (km)', 'FontSize', 10);
ylabel('Y coordinate (km)', 'FontSize', 10);
zlabel('Z coordinate (km)', 'FontSize', 10);
title('Chase maneuver', 'FontSize', 14);
grid on
axis equal;
%legend
lgd = legend('Initial orbit','Final orbit','Transfer trajectory',...
        'Transfer orbit','Initial position of spacecraft 1', ...
        'Initial position of spacecraft 2','Rendezvous point','X-axis',...
        'Y-axis','Z-axis','Earth');
lgd.FontSize = 12;
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%Set view and enable 3d rotation
view(50,20);
rotate3d on;