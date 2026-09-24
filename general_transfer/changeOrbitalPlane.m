function [DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OMi, omi, i_f, OMf)

% Change of Plane maneuver
%
% [DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OMi, omi, i_f, OMf)
%
% -----------------------------------------------------------------------
% Imput arguments:
% a             [1x1]   semi-major axis                      [km]
% e             [1x1]   eccentricity                         [-]
% i_i           [1x1]   initial inclination                  [rad]
% OMi           [1x1]   initial RAAN                         [rad]
% omi           [1x1]   initial pericenter anomaly           [rad]
% i_f           [1x1]   final inclination                    [rad]                     
% OMf           [1x1]   final RAAN                           [rad]
%
% -----------------------------------------------------------------------
% Output arguments:
% DeltaV        [1x1]   maneuver impulse                     [km/s]
% omf           [1x1]   final pericenter anomal              [km/s]
% theta         [1x1]   true anomaly at maneuver             [km/s]
% -----------------------------------------------------------------------
%
% La manovra cambia il piano dell'orbita --> variano i,OM e om
% Se la manovra è effettuata sull'asse dei nodi OM e om non variano
% ci sono 4 casi a seconda del segno di delta_OM e delta_i
%
% -----------------------------------------------------------------------

mu = 398600;

%% calcolo delta_OM e delta_i

delta_OM = OMf - OMi;
delta_i = i_f - i_i;

%% risoluzione dei triangoli sferici

if delta_OM > 0 && delta_i > 0
    
    alpha = acos(cos(i_i)*cos(i_f) + sin(i_i)*sin(i_f)*cos(delta_OM));
    
    cos_ui = (-cos(i_f) + cos(alpha)*cos(i_i))/(sin(alpha)*sin(i_i));
    cos_uf = (cos(i_i) - cos(alpha)*cos(i_f))/(sin(alpha)*sin(i_f));
    
    sin_ui = (sin(delta_OM)/sin(alpha))*sin(i_f);
    sin_uf = (sin(delta_OM)/sin(alpha))*sin(i_i);
    
    u_i = atan2(sin_ui, cos_ui);
    u_f = atan2(sin_uf, cos_uf);
    
    theta = u_i - omi;
    
    omf = u_f - theta;
    
    
elseif delta_OM > 0 && delta_i < 0
    
    alpha = acos(cos(i_i)*cos(i_f) + sin(i_i)*sin(i_f)*cos(delta_OM));
    
    cos_ui = (cos(i_f) - cos(alpha)*cos(i_i))/(sin(alpha)*sin(i_i));
    cos_uf = (-cos(i_i) + cos(alpha)*cos(i_f))/(sin(alpha)*sin(i_f));
    
    sin_ui = (sin(delta_OM)/sin(alpha))*sin(i_f);
    sin_uf = (sin(delta_OM)/sin(alpha))*sin(i_i);
    
    u_i = atan2(sin_ui, cos_ui);
    u_f = atan2(sin_uf, cos_uf);
    
    theta = 2*pi - u_i - omi;
    
    omf = 2*pi - u_f - theta; 
    
    
elseif delta_OM < 0 && delta_i > 0
    
    delta_OM = abs(delta_OM);
    
    alpha = acos(cos(i_i)*cos(i_f) + sin(i_i)*sin(i_f)*cos(delta_OM));
    
    cos_ui = (-cos(i_f) + cos(alpha)*cos(i_i))/(sin(alpha)*sin(i_i));
    cos_uf = (cos(i_i) - cos(alpha)*cos(i_f))/(sin(alpha)*sin(i_f));
    
    sin_ui = (sin(delta_OM)/sin(alpha))*sin(i_f);
    sin_uf = (sin(delta_OM)/sin(alpha))*sin(i_i);
    
    u_i = atan2(sin_ui, cos_ui);
    u_f = atan2(sin_uf, cos_uf);
    
    theta = 2*pi - u_i - omi;
    
    omf = 2*pi - u_f - theta;    
    
    
elseif delta_OM < 0 && delta_i < 0
    
    delta_OM = abs(delta_OM);
    
    alpha = acos(cos(i_i)*cos(i_f) + sin(i_i)*sin(i_f)*cos(delta_OM));
    
    cos_ui = (cos(i_f) - cos(alpha)*cos(i_i))/(sin(alpha)*sin(i_i));
    cos_uf = (-cos(i_i) + cos(alpha)*cos(i_f))/(sin(alpha)*sin(i_f));
    
    sin_ui = (sin(delta_OM)/sin(alpha))*sin(i_f);
    sin_uf = (sin(delta_OM)/sin(alpha))*sin(i_i);
    
    u_i = atan2(sin_ui, cos_ui);
    u_f = atan2(sin_uf, cos_uf);
    
    theta = u_i - omi;
    
    omf = u_f - theta;
    
end


if omf < 0
    omf = 2*pi + omf;
end 
    
%% calcolo costo manovra DeltaV

p = a * (1 - e^2);

if cos(theta) > 0
    theta = theta + pi;
    fprintf('Theta è nel primo o quarto quadrante, conviene quindi fare la manovra in tehta + pi = %f\n\n',theta)
end

V_theta = sqrt(mu/p) * (1 + e * cos(theta));

DeltaV = 2 * V_theta * sin(alpha/2);
    