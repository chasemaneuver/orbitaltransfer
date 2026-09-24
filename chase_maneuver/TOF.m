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
end
if  th2 > pi
    E_2 = E_2 + 2*pi;
end

%% calcolo tempo di volo

t_1 = sqrt((a^3) / mu) * (E_1 - e * sin(E_1));

t_2 = sqrt((a^3) / mu) * (E_2 - e * sin(E_2));

deltat = t_2 - t_1;

%% caso th2 < th1

T = 2 * pi * sqrt(a^3 / mu);

if th2 < th1
    deltat = deltat + T;
end

%% stampo

fprintf('\nIl delta t di volo da th1 a th2 è di: \n\ndelta t = %f [s]\ndelta t = %f [min]\ndelta t = %f [h]\n\n',deltat,deltat/60,deltat/3600);

end
