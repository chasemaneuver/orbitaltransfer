function [a, e, incl, RA, w, TA] = user_inputs(x)
%   This function takes user inputs
%
%   INPUT:
%       x    = 1 for initial orbit, 2 for final orbit 
%   OUTPUTS:
%       a    = semimajor axis (km)
%       e    = orbital eccentricity      - between 0 and 1
%       incl = inclination (deg)         - between 0 and 180 
%       RA   = right ascension (deg)     - between 0 and 360 
%       w    = argument of perigee (deg) - between 0 and 360
%       TA   = true anomaly (deg)        - between 0 and 360 

%% Initial or final orbit
if x == 1
    fprintf('\n***************\n');
    fprintf('Initial orbit\n');
    fprintf('***************\n');
elseif x == 2
    fprintf('\n***********\n');
    fprintf('Final orbit\n');
    fprintf('***********\n');
end

%% Semimajor axis
fprintf('\nInput the semimajor axis (kilometers)');
fprintf('\n(semimajor axis > 0)\n');
while(1)
    a = input('?');
    if a > 0
        break;
    end
end

%% Orbital eccentricity 
fprintf('\nInput the orbital eccentricity (non-dimensional)');
fprintf('\n(0 <= eccentricity < 1)\n');
while(1)
    e = input('?');
    if (e >= 0 && e <=1)
        break;
    end
end

%% Inclination, right ascension, argument of perigee
fprintf('\nInput the orbital inclination (degrees)');
fprintf('\n(0 <= inclination <= 180)\n');
while(1)
    incl = input('?');
    if (incl >= 0 && incl <= 180)
        break;
    end
end
if incl == 0
    RA = 0;
    w =0;
else
    fprintf('\nInput the right ascension of the ascending node (degrees)');
    fprintf('\n(0 <= right ascension of the ascending node <= 360)\n');
    while(1)
        RA = input('?');
        if (RA >= 0 && RA <= 360)
            break;
        end
    end
    fprintf('\nInput the argument of perigee (degrees)')
    fprintf('\n(0 <= argument of perigee <= 360)\n');
    while(1)
        w = input('?');
        if (w >= 0 && w <= 360)
            break;
        end
    end
end
fprintf('\nInput the true anomaly (degrees)');
fprintf('\n(0 <= true anomaly <= 360)\n');
while(1)
    TA = input('?');
    if (TA >= 0 && TA <= 360)
        break;
    end
end
end