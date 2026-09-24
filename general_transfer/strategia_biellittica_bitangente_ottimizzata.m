
clear all
close all
clc


th0 = 0;
thf = 2*pi;
dth = (thf-th0)/500;

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


%% attesa fino a pericentro

deltat_circ = TOF(a_i, e_i, th_i, 2*pi);

%% inizio manovra bitangente per circolarizzare orbita iniziale             
 % ho scelto di circolarizzare al pericentro in modo tale da avere velocità
 % maggiore per la manovra biellittica bitangente (effetto oberth)
 % Il tempo "perso" per andare dal punto iniziale al pericentro dovrebbe
 % essere trascurabile rispetto al tempo totale
 
 
p_i = a_i * (1 - e_i^2);                                                    % calcolo p e raggio pericentro orbita iniziale
rp_i = p_i / (1 + e_i);
a_circ = rp_i;                                                              % a = rp_i + rp_i / 2 = rp_i
e_circ = 0;                                                                 % e = 0 perchè circolare

 %selezionare manovra pericentro - apocentro
[DeltaV1_circ, DeltaV2_circ] = bitangentTransfer(a_i, e_i, a_circ, e_circ);        

%% individuo punto cambio di piano da cui far partire la manovra biellittica

[DeltaV_cop, om_f_sp, th_sp] = changeOrbitalPlane(a_circ, e_circ, i_i, OM_i, om_i, i_f, OM_f);  %trovo il punto in cui è possibile effettuare il cambio di piano, dal quale arto con la manovra biellittica bitangente (starting point)

deltat_sp = TOF(a_circ, e_circ, 0, th_sp);

%% trasferimento biellittico bitangente - T1

a_T1 = [];
e_T1 = [];

DeltaV_totale = [];
Deltat_totale = [];
DeltaV1_bbv = [];
DeltaV2_bbv = [];
DeltaV3_bbv = [];

    
for ra_T = [20000:100:30000]
    
[DeltaV1_bb, DeltaV2_bb, DeltaV3_bb, Deltat_bb] = bielliptic_bitangentTransfer(a_circ, e_circ, a_f, e_f, ra_T);       %ricavo i DeltaV e il Deltat della manovra

DeltaV1_bbv = [DeltaV1_bbv;DeltaV1_bb];
DeltaV2_bbv = [DeltaV2_bbv;DeltaV2_bb];
DeltaV3_bbv = [DeltaV3_bbv;DeltaV3_bb];

[RR_bb, VV_bb] = par2car(a_circ, e_circ, i_i, OM_i, om_i, th_sp);                                           %ricavo posizione e velocità sulla prima orbita in th_cop            

[a_T1, e_T1, i_T1, OM_T1, om_T1, th_T1] = car2par(RR_bb, VV_bb + DeltaV1_bb * (VV_bb/norm(VV_bb)));    %ricavo parametri orbitali orbita di trasferimento 1 a partire dalla posizione iniziale appena ricavata e velocità VV_i + DeltaV1                                   %ricavo posizione e velocità sull'orbita di trasferimento nel punto pigreco           


%% cambio di piano

[DeltaV_cop, om_f_cop, th_cop] = changeOrbitalPlane(a_T1, e_T1, i_T1, OM_T1, om_T1, i_f, OM_f);

%% rasferimento biellittico bitangente - T2

[RR_T1, VV_T1] = par2car(a_T1, e_T1, i_T1, OM_T1, om_T1, pi);               %ricavo posizione e velocità sull'orbita di trasferimento nel punto pigreco           

[a_T2, e_T2, i_T2, OM_T2, om_T2, th_T2] = car2par(RR_T1, VV_T1 + (DeltaV2_bb) * (VV_T1/norm(VV_T1)));

i_T2 = i_f;
OM_T2 = OM_f;                                                               % dato che non so in che direzione sommare il DeltaV_cop calcolo la traiettoria e poi aggiusto a posteriori OM, om e i
om_T2 = om_f_cop;                                                           % in ogni caso il risultato non cambia perche sommando il DeltaV_cop cambierei semplicemente l'orientazione del vettore velocità (e dell'orbita) ma non il suo modulo

%% cambio anomalia del pericentro

[DeltaV_cpa, th_inizio_manovra, th_nuova_orbita] = changePericenterArg(a_f, e_f, om_f_cop, om_f);  

%% calcolo tempo attesa punto finale

deltat_cp = TOF(a_f, e_f, 0 , th_inizio_manovra(2));

%% calcolo tempo attesa punto finale

deltat_pf = TOF(a_f, e_f, th_nuova_orbita(2) , th_f);

%% calcolo deltat e deltaV totali

DeltaV_totale = [DeltaV_totale; (abs(DeltaV_cop) + abs(DeltaV_cpa) + abs(DeltaV1_bb) + abs(DeltaV2_bb) + abs(DeltaV1_circ) + abs(DeltaV2_circ) + abs(DeltaV3_bb))];
Deltat_totale = [Deltat_totale; (Deltat_bb + deltat_circ + deltat_cp + deltat_pf + deltat_sp)];

%fprintf('\n\n\nDELTA_V TOTALE = %f [km/s]\nDELTA_t TOTALE = %f [s]  %f [min]    %f [h]\n\n', DeltaV_totale, Deltat_totale, Deltat_totale/60, Deltat_totale/3600);

end

ra_T = [20000:100:30000];

figure(1)
subplot(1,2,1)
plot (ra_T,DeltaV1_bbv,'r')
hold on
plot(ra_T, DeltaV2_bbv,'g') 
plot(ra_T, DeltaV3_bbv,'b')
plot(ra_T, DeltaV_totale','c')

subplot(1,2,2)
plot(ra_T, Deltat_totale);

% %% plot
% 
% lgd = legend('-DynamicLegend');                                                           
% lgd.Title.String = 'Orbita iniziale:               Orbita finale:          Cambio di piano:          Cambio anomalia pericentro:          Orbita trasferimento:';                             %aggiunge titolo alla legenda
% lgd.Title.FontSize = 10;                                                                
% lgd.NumColumns = 6;                                                                       
% lgd.ItemHitFcn = @hitcallback;                                                                                                                      % //vedi commenti funzione//
% hold off
% 
% figure(1)                                                                   
% hold on
% plot3(R_i(1), R_i(2), R_i(3),'ro','Linewidth',2,'DisplayName','Punto iniziale'); %stampo punto iniziale     
% 
% figure(1)
% hold on
% plot3(R_f(1), R_f(2), R_f(3),'rx','Linewidth', 2,'DisplayName','Punto finale');
% 
% figure(1)
% hold on
% plotOrbit(a_i, e_i, i_i, OM_i, om_i, th0, thf, dth,'tr');                   %orbita iniziale
% 
% figure(1)
% hold on
% plotOrbit(a_f, e_f, i_f, OM_f, om_f, th0, thf, dth,'tr');
% 
% figure(1)
% hold on
% R_vect1 = plotOrbit(a_i, e_i, i_i, OM_i, om_i, th_i, 2*pi, dth);
% 
% figure(1)
% hold on
% R_vect2 = plotOrbit(a_circ, e_circ, i_i, OM_i, om_i, th0, th_sp, dth);
% 
% figure(1)
% hold on
% R_vect3 = plotOrbit(a_T1, e_T1, i_T1, OM_T1, om_T1, 0, pi, dth);
% 
% figure(1)
% hold on
% R_vect4 = plotOrbit(a_T2, e_T2, i_T2, OM_T2, om_T2, pi, 2*pi, dth);
% 
% figure(1)
% hold on
% plotOrbit(a_f, e_f, i_f, OM_f, om_T2, th0, thf, dth,'tr');
% 
% figure(1)
% hold on
% R_vect5 = plotOrbit(a_f, e_f, i_f, OM_f, om_f_cop, 0, th_inizio_manovra(2), dth);
% 
% figure(1)
% hold on
% R_vect6 = plotOrbit(a_f, e_f, i_f, OM_f, om_f, th_nuova_orbita(2), 2*pi + th_f, dth);
% 
% %% animazione 
% 
% figure(2)
% 
% R_vect = [R_vect1, R_vect2, R_vect3, R_vect4, R_vect5, R_vect6];            %unisco tutti i vettori posizione colonna uno dopo l'altro
% 
% figure(2)
% hold on
% plotOrbit(a_i, e_i, i_i, OM_i, om_i, th0, thf, dth,'tr');                   %
%                                                                             %
% figure(2)                                                                   %stampo orbita iniziale e finale
% hold on                                                                     %
% plotOrbit(a_f, e_f, i_f, OM_f, om_f, th0, thf, dth,'tr');                   %
% 
% figure(2)                                                                   
% hold on
% plot3(R_i(1), R_i(2), R_i(3),'ro','Linewidth',2,'DisplayName','Punto iniziale'); %stampo punto iniziale     
% 
% figure(2)
% hold on
% plot3(R_f(1), R_f(2), R_f(3),'rx','Linewidth', 2,'DisplayName','Punto finale'); %stampo punto finale
% 
% figure(2)                                                                   %stampo animazione
% hold on
% comet3(R_vect(1,:), R_vect(2,:), R_vect(3,:));
