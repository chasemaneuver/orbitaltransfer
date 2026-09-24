clear all
close all
clc

%% inserimento dati iniziali

R_i = [-1911.9028 -7939.5588 -4061.291];
V_i = [5.539 -0.3066 -2.98];

[a_i, e_i, i_i, OM_i, om_i, th_i] = car2par(R_i, V_i);

%% inserimento dati finali

a_f = 12650;
e_f = 0.2211;
i_f = 1.461;
OM_f = 1.618;
om_f = 1.93; 
th_f = 1.939;

[R_f, V_f] = par2car(a_f, e_f, i_f, OM_f, om_f, th_f);


%% cambio di piano

[DeltaV_cop, om_i_cop, th_cop] = changeOrbitalPlane(a_i, e_i, i_i, OM_i, om_i, i_f, OM_f);  %cambio piano per avere stessa i e stessa OM dell'orbita finale

Deltat_cop = TOF(a_i, e_i, th_i, th_cop);                                   %Delta t tra l'angolo iniziale e l'angolo della manovra per il cambio di piano

%% cambio anomalia pericentro

[DeltaV_cpa, th_inizio_manovra, th_nuova_orbita] = changePericenterArg(a_i, e_i, om_i_cop, om_f);   %cambio anomalia pericentro da quella iniziale om_i_cop a quella finale

Deltat_cpa = TOF(a_i, e_i, th_cop, th_inizio_manovra(2));                   %Deltat tra angolo manovra cambio piano e angolo manovra cambio anomalia pericentro
                                                                            %è è stato scelto th_inizio_manovra(2) perchè più vicino 
%% attesa fino al pericentro

Deltat_pericentro = TOF(a_i, e_i, th_nuova_orbita(2), 2*pi);                %Deltat tra anglo manovra pericentro (su orbita ruotata) e pericentro

%% trasferimento bitangente

[DeltaV1_bt, DeltaV2_bt, Deltat_bt] = bitangentTransfer(a_i, e_i, a_f, e_f);    %trasferimento bitangente da pericentro orbita iniziale (ruotata + cambio piano) a orbita finale

%% calcolo tempo arrivo punto finale

Deltat_pf = TOF(a_f, e_f, pi, th_f);                                        %Deltat da apocentro a punto finale

%% calcolo deltat e deltaV totali

DeltaV_totale = abs(DeltaV_cop) + abs(DeltaV_cpa) + abs(DeltaV1_bt) + abs(DeltaV2_bt);
Deltat_totale = Deltat_cop + Deltat_cpa + Deltat_pericentro + Deltat_bt + Deltat_pf;

fprintf('\n\n\nDELTA_V TOTALE = %f [km/s]\nDELTA_t TOTALE = %f [s]  %f [min]    %f [h]\n\n', DeltaV_totale, Deltat_totale, Deltat_totale/60, Deltat_totale/3600);

%% plot

th0 = 0;
thf = 2*pi;
dth = (thf-th0)/500;

lgd = legend('-DynamicLegend');                                                           
lgd.Title.String = 'Orbita iniziale:               Orbita finale:          Cambio di piano:          Cambio anomalia pericentro:          Orbita trasferimento:';                             %aggiunge titolo alla legenda
lgd.Title.FontSize = 10;                                                                
lgd.NumColumns = 6;                                                                       
lgd.ItemHitFcn = @hitcallback;                                                                                                                      % //vedi commenti funzione//
hold off

% per stampare l'orbita iniziale e finale complete decommentare:

figure(1)
hold on
plotOrbit(a_i, e_i, i_i, OM_i, om_i, th0, thf, dth,'tr');  

figure(1)
hold on
plotOrbit(a_f, e_f, i_f, OM_f, om_f, th0, thf, dth,'tr');

figure(1)                                                                   
hold on
plot3(R_i(1), R_i(2), R_i(3),'ko','Linewidth',2,'DisplayName','Punto iniziale'); %stampo punto iniziale     

figure(1)
hold on
plot3(R_f(1), R_f(2), R_f(3),'kx','Linewidth', 2,'DisplayName','Punto finale'); %stampo punto finale

figure(1)
hold on
R_vect1 = plotOrbit(a_i, e_i, i_i, OM_i, om_i, th_i, th_cop, dth);          %stampo il tratto dal punto iniziale al punto di cambio piano 


figure(1)
hold on
R_vect2 = plotOrbit(a_i, e_i, i_f, OM_f, om_i_cop, th_cop, th_inizio_manovra(2), dth); %stampo tratto da cambio piano a cambio anomalia pericentro

figure(1)
hold on
R_vect3 = plotOrbit(a_i, e_i, i_f, OM_f, om_f, th_nuova_orbita(2), 2*pi, dth);        %stampo tratto da cambio anomalia pericentro a pericentro



[RR_trasferimento, VV_trasferimento] = par2car(a_i, e_i, i_f, OM_f, om_f, 0);

[a_T, e_T, i_T, OM_T, om_T, th_T] = car2par(RR_trasferimento, VV_trasferimento + DeltaV1_bt * VV_trasferimento/norm(VV_trasferimento));
th_T = 0;                                                                   %veniva un numero complesso praticamente uguale a 0 non so perchè

figure(1)
hold on
R_vect4 = plotOrbit(a_T, e_T, i_T, OM_T, om_T, 0, pi, dth);                 %stampo trasferimento

figure(1)
hold on
R_vect5 = plotOrbit(a_f, e_f, i_f, OM_f, om_f, pi, 2*pi+th_f, dth);         %stampo tratto da apocentro a th_f


%% animazione 

figure(2)

R_vect = [R_vect1, R_vect2, R_vect3, R_vect4, R_vect5];                     %unisco tutti i vettori posizione colonna uno dopo l'altro

figure(2)
plotOrbit(a_i, e_i, i_i, OM_i, om_i, th0, thf, dth,'tr');                   %
                                                                            %
figure(2)                                                                   %stampo orbita iniziale e finale
hold on                                                                     %
plotOrbit(a_f, e_f, i_f, OM_f, om_f, th0, thf, dth,'tr');                   %

figure(2)                                                                   
hold on
plot3(R_i(1), R_i(2), R_i(3),'ko','Linewidth',2,'DisplayName','Punto iniziale'); %stampo punto iniziale     

figure(2)
hold on
plot3(R_f(1), R_f(2), R_f(3),'kx','Linewidth', 2,'DisplayName','Punto finale'); %stampo punto finale

figure(2)                                                                   %stampo animazione
hold on
comet3(R_vect(1,:), R_vect(2,:), R_vect(3,:));
