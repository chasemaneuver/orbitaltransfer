function [DeltaV, th_iniziale, th_finale] = changePericenterArg(a, e, omi, omf)

% Change of Pericenter Argument maneuver
%
% [DeltaV, thetai, thetaf] = changePericenterArg(a, e, omi, omf)
%
% -----------------------------------------------------------------------
% Imput arguments:
% a             [1x1]   semi-major axis                      [km]
% e             [1x1]   eccentricity                         [-]
% omi           [1x1]   initial pericenter anomaly           [rad]
% omf           [1x1]   final pericenter anomaly             [rad]
%
% -----------------------------------------------------------------------
% Output arguments:
% DeltaV        [1x1]   maneuver impulse                     [km/s]
% th_iniziale   [2x1]   initial true anomalies               [rad]
% th_finale     [2x1]   final true anomalies                 [rad]
%
% -----------------------------------------------------------------------
%
% La manovra cambia l'anomalia del pericentro om mantenendo invariati 
% "a" ed "e"
% La manovra può avvenire in due punti e DeltaV non dipende da essi 
% -----------------------------------------------------------------------

mu = 398600;

%% Calcolo anomalie vere iniziali e finali

delta_om = omf - omi;

th_iniziale = [delta_om/2, pi + delta_om/2];
th_finale = [2*pi-delta_om/2, pi - delta_om/2];

%% Calcolo costo manovra

p = a*(1-e^2);

DeltaV = 2*sqrt(mu/p)*e*sin(delta_om/2);

%% Stampo

fprintf('\n\n Le anomalie vere in cui è possibile effettuare la manovra sono theta_1 = %f rad e theta_2 = %f rad',th_iniziale);
fprintf('\n\n Che sulla nuova orbita corrispondono a theta_1 = %f rad e theta_2 = %f rad',th_finale);
fprintf('\n\n Il costo della manovra è deltaV = %f km/s \n',DeltaV);

end


