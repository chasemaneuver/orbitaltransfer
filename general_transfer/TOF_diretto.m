function th = TOF_diretto(a, e, deltat)

% Time of flight
% 
% th = TOF_diretto(a, e, deltat)
% 
% -----------------------------------------------------------------------
% Input arguments:
% a             [1x1]   semi-major axis                      [km]
% e             [1x1]   eccentricity                         [-]
% Deltat        [1x1]   time of flight                       [s]
%
% -----------------------------------------------------------------------
% Output arguments:
% th            [1x1]   true anomaly                         [rad]
%
% -----------------------------------------------------------------------
% Lo script calcola la posizione sull'orbita th dato il tempo di volo
% -----------------------------------------------------------------------

mu = 398600;

%% calcolo anomalia media M
 
M = sqrt(mu/a^3) * deltat;

%% calcolo anomalia eccentrica E

fun = @(E) E - e * sin(E) - M;
dfun = @(E) 1 - e * cos(E);

[xvect,it]=biseznewton(0,2*pi,1000,1000,1e-6,fun,dfun);

E = xvect(end);

%% calcolo th2

th = 2 * atan(tan(E/2) * sqrt((1+e)/(1-e)));

%% stampo

fprintf('\n\nL anomalia vera è th = %f\n\n', th)

