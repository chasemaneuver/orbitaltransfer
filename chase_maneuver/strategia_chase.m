%% CASO 2

% CHASE:
%   Caso 2.1
%   Caso 2.2
%   Caso 2.3

% Per ogni caso, 2 step:
% 1 Step: Calcolo DeltaV e Deltat_iniziale
% 2 Step: Calcolo Deltat_totale


clear all
close all
clc


%% Caso 2.1
% ------------- 1 Step: Calcolo DeltaV e Deltat_iniziale


% delta_t iniziale = Periodo orbita finale

main
% inserire 1 - posigrade
% inserire t = T_orbita_finale =  14159.470384   [s]

% -------------  2 Step: Calcolo Deltat_totale

a =   +1.38815406608083e+04   ;
e =  +9.86687828924319e-01  ;
th1 =+1.66580359207366e+02   *pi/180;
th2 =+1.89927178681586e+02  * pi/180;
 deltat_manovra = TOF(a, e, th1, th2);
 deltat_totale = deltat_manovra + delta_t;
 
 fprintf('\n\n ------ CASO 2.1 -----------\n\n');
 fprintf('\n\nIl tempo totale di volo è:    %f [s]', deltat_totale)
 

%% Caso 2.2

% delta_t iniziale = Periodo orbita iniziale


hold on
main
% inserire 1 - posigrade
% inserire t = T_orbita_iniziale =    7589.973445    [s]

% -------------  2 Step: Calcolo Deltat_totale

a =  +1.13211843039574e+04   ;
e =  +1.97619069038700e-01  ;
th1 = +1.26854301337863e+01 *180/pi;
th2 = +2.19943588845845e+02 * 180/pi;
 deltat_manovra = TOF(a, e, th1, th2);
 a =  +1.26500000000000e+04   ;
e =  +2.21100000000000e-01  ;
th1 = +2.19943588845845e+02  *180/pi;
th2 =  +1.11096516475867e+02  * 180/pi;
 deltat_finale =  TOF(a, e, th1, th2);
 deltat_totale = deltat_manovra + delta_t + deltat_finale;
 
  fprintf('\n\n ------ CASO 2.2 -----------\n\n');
 fprintf('\n\nIl tempo totale di volo è:    %f [s]', deltat_totale)
 

%% Caso 2.3

% delta_t iniziale = t_ottimzzata
% Simile a periodo orbita iniziale con partenza da 3/2 pi

main2
% inserire 1 - posigrade
% inserire t =~ T_orbita_iniziale =        7590.000000     [s]

% -------------  2 Step: Calcolo Deltat_totale

a =  +1.05316177591759e+04  ;
e =+2.91439128626984e-01 ;
th1 = +3.05687597956908e+02 *180/pi ;
th2 =  +2.05628214182655e+02  *180/pi ;
 deltat_manovra = TOF(a, e, th1, th2)
 deltat_totale = deltat_manovra + delta_t;
  
  fprintf('\n\n ------ CASO 2.3 -----------\n\n');
 fprintf('\n\nIl tempo totale di volo è:    %f [s]', deltat_totale);