function [a, e, i, OM, om, th] = car2par(RR, VV)

% Transformation from cartesian coordinates to Keplerian parameters
% 
% [a, e, i, OM, om, th] = car2par(rr, vv, mu)
% 
% Dati RR e VV in coordinate geocentriche inerziali 
% (ECI, sist. di riferim. celeste) ricavo i parametri orbitali
% ------------------------------------------------------------------------
% Imput arguments:
% RR            [3x1]   position vector                      [km]
% VV            [3x1]   velocity vector                      [km/s]
% mu            [1x1]   gravitational parameter              [km^3/s^2]
% 
% ------------------------------------------------------------------------
% Output arguments:
% a             [1x1]   semi-major axis                      [km]
% e             [1x1]   eccentricity                         [-]
% i             [1x2]   inclination                          [rad]
% OM            [1x2]   RAAN                                 [rad]
% om            [1x2]   pericenter anomaly                   [rad]
% th            [1x2]   true anomaly                         [rad]
% 
% ------------------------------------------------------------------------

I = [1, 0, 0];
J = [0, 1, 0];
K = [0, 0, 1];

mu = 398600;

%% 1. norma vettori posizione e velocità

R = norm(RR);                                                               %norma vettore posizione
V = norm(VV);                                                               %norma vettore velocità

%% 2. semiasse maggiore - a

a = 1/(2/R - (V^2)/mu);                                                     %semiasse maggiore

%% 3. vettore momento angolare - h

hh = cross(RR,VV);                                                          %vettore momento angolare

h = norm(hh);                                                               %norma vettore momento angolare

%% 4. eccentricità - e

ee = cross(VV,hh)/mu - RR/R;                                                %vettore eccentricità

e = norm(ee);                                                               %eccentricità

%% 5. inclinazione - i

i = acos(hh(3)/h);                                                          %inclinazione

%% 6. versore linea dei nodi - N

N = cross(K,hh)/norm(cross(K,hh));                                          %versore linea dei nodi

%% 7. ascensione retta del nodo ascendente (RAAN) - OM

if (N(2) >= 0)
    OM = acos(N(1));
else
    OM = 2*pi - acos(N(1));
end

%% 8. anomalia pericentro - om

if ee(3) >= 0
    om = acos(dot(N,ee)/e);
else
    om = 2*pi - acos(dot(N,ee)/e);
end

%% 9. anomalia vera - th

Vr = dot(VV,RR)/R;

if Vr > 0
    th = acos(dot(RR,ee)/(R*e));
elseif Vr < 0
    th = 2*pi - acos(dot(RR,ee)/(R*e));
else
    disp('\n\n vr � uguale a 0, il punto si trova al pericentro/apocentro');
    th = 0;
end

end