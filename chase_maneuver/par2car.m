function [RR, VV] = par2car(a, e, i, OM, om, th)

% Transformation from cartesian coordinates to Keplerian parameters
%
% Dati i parametri orbitali, ricavo vv e rr nel sistema di riferimento
% perifocale (PF), poi ruoto per ottenere RR e VV nel sistema di 
% riferimento celeste (ECI)

% [RR, VV] = par2car(a, e, i, OM, om, th)
% 
% ------------------------------------------------------------------------
% Imput arguments:
% a             [1x1]   semi-major axis                      [km]
% e             [1x1]   eccentricity                         [-]
% i             [1x1]   inclination                          [rad]
% OM            [1x1]   RAAN                                 [rad]
% om            [1x1]   pericenter anomaly                   [rad]
% th            [1x1]   true anomaly                         [rad]
% mu            [1x1]   gravitational parameter              [km^3/s^2]
% 
% ------------------------------------------------------------------------
% Output arguments:
% RR            [3x1]   position vector                      [km]
% VV            [3x1]   velocity vector                      [km/s]
% 
% ------------------------------------------------------------------------

mu = 398600;

%% 0. matrix definition

R_OM = [cos(OM)     sin(OM)     0;...
        -sin(OM)    cos(OM)     0;...
            0         0         1];
        
R_i = [1     0          0;...
       0    cos(i)     sin(i);...
       0   -sin(i)     cos(i)];
 
R_om = [cos(om)     sin(om)     0;...
        -sin(om)    cos(om)     0;...
            0         0         1];
        

T_ECI_PF = R_om * R_i * R_OM;                                               %matrice di rotazione totale

T_PF_ECI = T_ECI_PF';                                                       %T_PF_ECI = T_ECI_PF' = R_OM' * R_i' * R_om'

%% 1. posizione e velocità in PF

p = a*(1-e^2);                                                              %semilato retto

r = p / (1 + e*cos(th));                                                    %modulo posizione

rr = r * [cos(th), sin(th), 0]';                                            %vettore posizione in PF

vv = sqrt(mu/p) * [-sin(th), e + cos(th), 0]';                              %vettore velocità in PF

%% 2. posizione e velocità in ECI

RR = T_PF_ECI*rr;

VV = T_PF_ECI*vv;


end