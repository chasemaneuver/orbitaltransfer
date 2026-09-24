function deltat = TOF(a, e, th1, th2)

% Time of flight
% 
% deltat = TOF(a, e, th1, th2)
% 
% -----------------------------------------------------------------------
% Input arguments:
% a             [1x1]   semi-major axis                      [km]
% e             [1x1]   eccentricity                         [-]
% th1           [1x1]   initial true anomaly                 [rad]
% th2           [1x1]   final true anomaly                   [rad]
%
% -----------------------------------------------------------------------
% Output arguments:
% Deltat        [1x1]   time of flight                       [s]
%
% -----------------------------------------------------------------------
% Lo script calcola il tempo di volo dal punto th1 al punto th2
% -----------------------------------------------------------------------

mu = 398600;

%% calcolo anomalie eccentriche E1 & E2 

E_1 = 2 * atan(sqrt((1-e)/(1+e)) * tan(th1/2));

E_2 = 2 * atan(sqrt((1-e)/(1+e)) * tan(th2/2));

if th1 > pi
    E_1 = E_1 + 2*pi;
elseif th2 > pi
    E_2 = E_2 + 2*pi;
end
