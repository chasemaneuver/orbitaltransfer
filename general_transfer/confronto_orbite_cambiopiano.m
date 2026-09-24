close all
clc
clear all 

%-------------------------------------------------------------------------
% Lo script permette di stampare l'orbita iniziale e finale assegnate
%-------------------------------------------------------------------------

th0 = 0;
thf = 2*pi;
dth = (thf-th0)/500;
                                                                   

%% ORBITA INIZIALE

RR_1 = [-1911.9028, -7939.5588, -4061.291]';                                %posizione iniziale
VV_1 = [5.539, -0.3066, -2.98]';                                            %velocità iniziale

[a_1, e_1, i_1, OM_1, om_1, th_1] = car2par(RR_1, VV_1);                    %ricavo parametri orbitali orbita iniziale

plotOrbit(a_1, e_1, i_1, OM_1, om_1, th0, thf, dth);                         %stampo orbita iniziale


figure(1)                                                                   %richiamo la figure(1) per stamparci dentro
hold on
plot3(RR_1(1), RR_1(2), RR_1(3),'ko','Linewidth',2,'DisplayName','Punto iniziale');       %stampo il punto iniziale
hold off

%% ORBITA FINALE

a_2 = 12650;
e_2 = 0.2211; 
i_2 = 1.461;
OM_2 = 1.618;
om_2 = 1.93;
th_2 = 1.939;

[RR_2, VV_2] = par2car(a_2, e_2, i_2, OM_2, om_2, th_2);                    %ricavo posizione e velocità nel punto finale
                                                                                                                       
figure(1)                                                                   
hold on
    
plotOrbit(a_2, e_2, i_2, OM_2, om_2, th0, thf, dth);                         %stampo orbita finale


figure(1)
hold on
plot3(RR_2(1), RR_2(2), RR_2(3),'kx','Linewidth', 2,'DisplayName','Punto finale');         %stampo il punto finale
lgd = legend('-DynamicLegend');                                                            %richiama la legenda di ploOrbit 
lgd.Title.String = 'Orbita iniziale:          Orbita finale:          Orbita iniziale ruotata:';                             %aggiunge titolo alla legenda
lgd.Title.FontSize = 10;                                                                
lgd.NumColumns = 3;                                                                        %divide la legenda in due colonne
lgd.ItemHitFcn = @hitcallback;                                                             % //vedi commenti funzione//                                                            % //vedi commenti funzione//
hold off

% figure(2)
% hold on
% title('Andamento della velocità iniziale')
% hold off
% 
% figure(3)
% hold on
% title('Andamento della velocità finale')
% hold off

%% ORBITA INIZIALE RUOTATA

i_f = i_2;                                                                  %pongo i_f e OMf uguali a quelli dell'orbita finale, per rendere le orbite complanari
OMf = OM_2;

[DeltaV, omf, theta] = changeOrbitalPlane(a_1, e_1, i_1, OM_1, om_1, i_f, OMf);


figure(1)
hold on
plotOrbit(a_1, e_1, i_f, OMf, omf, th0, thf, dth);                          %stampo ancora l'orbita iniziale (stessa a,e), ma nel nuovo piano (i,OM,om diversi) --> se non si dovessero visualizzare i vettori h ed N, è perchè sono sovrapposti a quelli dell'orbita finale

[RR_manovra, VV_manovra] = par2car(a_1, e_1, i_1, OM_1, om_1, theta);       %calcolo la posizione del punto di intersezione sull'orbita iniziale nel quale si effettua la manovra
                                                                            %nel caso in cui theta appartenga al primo o quarto quadrante è già stato considerato il theta diametralmente opposto (theta + pi) in changeOrbitalPlane.m
figure(1)
hold on
plot3(RR_manovra(1), RR_manovra(2), RR_manovra(3),'k*','Linewidth',2,...    %stampo il punto di manovra
     'DisplayName','Punto inizio manovra');
