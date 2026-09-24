function [DeltaV1, DeltaV2, DeltaV3, Deltat] = bielliptic_bitangentTransfer(a_i, e_i, a_f, e_f, ra_T1)

% Bielliptic bitangent transfer for elliptic orbits
%
% [DeltaV1, DeltaV2, Deltat] = bielliptic_bitangentTransfer(a_i, e_i, a_f, e_f, a_T1, e_T1)
%
% -----------------------------------------------------------------------
% Imput arguments:
% a_i           [1x1]   initial semi-major axis              [km]
% e_i           [1x1]   initial eccentricity                 [-]
% a_f           [1x1]   final semi-major axis                [km]
% e_f           [1x1]   final eccentricity                   [-]
% a_T1          [1x1]   1st transfer orbit semi-major axis   [km] 
% e_T1          [1x1]   1st transfer orbit eccentricity      [-] 
%
% -----------------------------------------------------------------------
% Output arguments:
% DeltaV1       [1x1]   1st maneuver impulse                 [km/s]
% DeltaV2       [1x1]   2nd maneuver impulse                 [km/s]
% DeltaV3       [1x1]   3nd maneuver impulse                 [km/s]
% Deltat        [1x1]   maneuver time                        [km/s]
% -----------------------------------------------------------------------
%
% La manovra cambia "a" ed "e" dellorbita mantenendo invariato "om" 
%
% La manovra ha sempre luogo al pericentro, per effetto Oberth 
%
% La manovra è a tre impulsi
%
% -----------------------------------------------------------------------

mu = 398600;

a = @(ra,rp) (ra + rp)/2;                                                   %semiasse maggiore
v = @(r,a) sqrt(mu)*sqrt(2/r - 1/a);                                        %velocità

%% calcolo costo manovra
        
        rp_T1 = a_i * (1 - e_i);                                             %raggio pericentro orbita di trasferimento
        
        rp_T2 = a_f * (1 - e_f);                                             %raggio apocentro orbita di trasferimento
        ra_T2 = ra_T1;
        
        a_T1 = a(ra_T1, rp_T1)                                                %semiasse magiore orbita di trasferimento
        a_T2 = a(ra_T2, rp_T2)
        
        DeltaV1 = v(rp_T1, a_T1) - v(rp_T1, a_i);                              %DeltaV1 = vp_T - vp_i
        DeltaV2 = v(ra_T2, a_T2) - v(ra_T1, a_T1);                              %DeltaV2 = va_f - va_T
        DeltaV3 = v(rp_T2, a_f) - v(rp_T2, a_T2);
        
%% calcolo deltaT

Deltat1 = pi * sqrt((a_T1^3)/mu);
Deltat2 = pi * sqrt((a_T2^3)/mu);
Deltat = Deltat1 + Deltat2;

%% stampo

fprintf('\n\nIl costo delle manovre è di: \nDeltaV1 = %f km/s \nDeltaV2 = %f km/s \nDeltaV3 = %f km/s',DeltaV1,DeltaV2,DeltaV3)
fprintf('\n\nIl costo totale è DeltaV_tot = %f km/s',abs(DeltaV1)+abs(DeltaV2)+abs(DeltaV3))
fprintf('\n\nIl tempo di manovra è Deltat = %f s \n',Deltat)

