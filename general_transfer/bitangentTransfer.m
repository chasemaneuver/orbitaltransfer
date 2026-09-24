function [DeltaV1, DeltaV2, Deltat] = bitangentTransfer(a_i, e_i, a_f, e_f)

% Bitangent transfer for elliptic orbits
%
% [DeltaV1, DeltaV2, Deltat] = bitangentTransfer(a_i, e_i, a_f, e_f, type)
%
% -----------------------------------------------------------------------
% Imput arguments:
% a_i           [1x1]   initial semi-major axis              [km]
% e_i           [1x1]   initial eccentricity                 [-]
% a_f           [1x1]   final semi-major axis                [km]
% e_f           [1x1]   final eccentricity                   [-]
% type          [char]  maneuver type                        
%
% -----------------------------------------------------------------------
% Output arguments:
% DeltaV1       [1x1]   1st maneuver impulse                 [km/s]
% DeltaV        [1x1]   2nd maneuver impulse                 [km/s]
% Deltat        [1x1]   maneuver time                        [km/s]
% -----------------------------------------------------------------------
%
% La manovra cambia "a" ed "e" dellorbita mantenendo invariato "om" 
% oppure "th" a seconda del tipo di manovra
%
% SE e_i = e_f = 0 SI OTTIENE IL CASO PARTICOLARE DI TRASFERIMENTO ALLA 
% HOHMANN CON UNA QUALSIASI DELLE 4 MANOVRE 
%
% La manovra è a due impulsi
% -----------------------------------------------------------------------

mu = 398600;

a = @(ra,rp) (ra + rp)/2;                                                   %semiasse maggiore
v = @(r,a) sqrt(mu)*sqrt(2/r - 1/a);                                        %velocità

%% selezione tipo di manovra

list = {'Pericentro - Apocentro', 'Apocentro - Pericentro',...
        'Pericentro - Pericentro', 'Apocentro - Apocentro'};
    
[type,tf] = listdlg('ListString',list,'PromptString',...                    
            'Seleziona il tipo di manovra (SELEZIONARE SOLO 1):');
    
%% calcolo costo manovre

switch type
    
    case 1 %Pericentro - Apocentro
        
        rp_T = a_i * (1 - e_i);                                             %raggio pericentro orbita di trasferimento
        ra_T = a_f * (1 + e_f);                                             %raggio apocentro orbita di trasferimento
        
        a_T = a(ra_T, rp_T);                                                %semiasse magiore orbita di trasferimento
         
        DeltaV1 = v(rp_T, a_T) - v(rp_T, a_i);                              %DeltaV1 = vp_T - vp_i
        DeltaV2 = v(ra_T, a_f) - v(ra_T, a_T);                              %DeltaV2 = va_f - va_T
        
    case 2 %Apoentro - Pericentro
        
        ra_T = a_i * (1 + e_i);                                             %raggio apocentro orbita di trasferimento
        rp_T = a_f * (1 - e_f);                                             %raggio pericentro orbita di trasferimento
        
        a_T = a(ra_T, rp_T);                                                %semiasse magiore orbita di trasferimento
         
        DeltaV1 = v(ra_T, a_T) - v(ra_T, a_i);                              %DeltaV1 = va_T - va_i
        DeltaV2 = v(rp_T, a_f) - v(rp_T, a_T);                              %DeltaV2 = vp_f - vp_T
        
    case 3 %Pericentro - Pericentro
        
        rp_T = a_i * (1 - e_i);                                             %raggio pericentro orbita di trasferimento
        ra_T = a_f * (1 - e_f);                                             %raggio apocentro orbita di trasferimento
        
        a_T = a(ra_T, rp_T);                                                %semiasse magiore orbita di trasferimento
         
        DeltaV1 = v(rp_T, a_T) - v(rp_T, a_i);                              %DeltaV1 = vp_T - vp_i
        DeltaV2 = v(ra_T, a_f) - v(ra_T, a_T);                              %DeltaV2 = vp_f - va_T
        
    case 4 %Apocentro - Apocentro
        
        rp_T = a_i * (1 + e_i);                                             %raggio apocentro orbita di trasferimento
        ra_T = a_f * (1 + e_f);                                             %raggio pericentro orbita di trasferimento
        
        a_T = a(ra_T, rp_T);                                                %semiasse magiore orbita di trasferimento
         
        DeltaV1 = v(rp_T, a_T) - v(rp_T, a_i);                              %DeltaV1 = vp_T - va_i
        DeltaV2 = v(ra_T, a_f) - v(ra_T, a_T);                              %DeltaV2 = va_f - va_T
        
end

%% calcolo deltaT

Deltat = pi * sqrt((a_T^3)/mu);

%% stampo

fprintf('\n\n Il costo delle manovre è di: DeltaV1 = %f km/s e DeltaV2 = %f km/s',DeltaV1,DeltaV2)
fprintf('\n\n Il costo totale è DeltaV_tot = %f km/s',abs(DeltaV1)+abs(DeltaV2))
fprintf('\n\n Il tempo di manovra è Deltat = %f s \n',Deltat)

