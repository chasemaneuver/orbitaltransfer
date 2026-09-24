%
% Alcune righe di codice che possono essere utili per stampare le manovre
% assieme alle orbite
%

%% changePericenterArg plot
%
% Dati iniziali:
%
% a,e,i,OM,om,th --> devo partire da un orbita iniziale
% omi, omf --> ovvero devo sapere di quanto voglio ruotare l'robita
% thi = 0;
% thf = 2*pi;


[DeltaV, th_iniziale, th_finale] = changePericenterArg(a, e, omi, omf);     %dove omi = om orbita di partenza, omf = om orbita di arrivo = omi + incremento

[RR, VV] = par2car(a, e, i, OM, om, th_iniziale);                           %calcola la posizione RR sull'orbita di partenza in corrspondenza di th = th_iniziale
                                                                            %th_iniziale è un vettore, bisogna scegliere una delle 2 posizioni possibili

plotOrbit(a, e, i, OM, omf, thi, thf, dth)                                  %stampa un'orbita con gli stessi parametri di quelli di partenza, fatta eccezione per om che diventa omf
                                                                            %--> l'orbita ruota soltanto attorno al fuoco, senza cambiare gli altri parametri
                                                                            %thi e thf sono gli intervalli in cui stampare l'orbita, non th_iniziale e th_finale!!!
                                                                            
%% bitangentTransfer Plot
%
% Dati iniziali:
%
% a, e, i, OM, om, th --> devo partire da un orbita iniziale
% a_i, e_i, a_f, e_f --> ovvero devo conoscere a,e di orbita iniziale e finale


[DeltaV1, DeltaV2, Deltat] = bitangentTransfer(a_i, e_i, a_f, e_f);         %ricavo i deltaV e deltaT necessari per passare da orbita iniziale a finale

[RR, VV] = par2car(a, e, i, OM, om, th);                                    %ricavo posizione e velocità nel punto di partenza sull'orbita iniziale 
                                                                            %th sarà pari a 0 o pigreco a seconda del tipo di manovra (possibile implementazione automatica tramite switch-case prendendo il valore di type da bitangentTransfer.m)
                                                                            
[a_T, e_T, i_T, OM_T, om_T, th_T] = car2par(RR, VV + DeltaV1*(VV/norm(VV)));%calcolo parametri orbitali dell'orbita di trasferimento a partire dalla posizione iniziale RR e velocità iniziale VV + DeltaV1

plotOrbit(a_T, e_T, i_T, OM_T, om_T, thi, thf, dth);                        %stampo orbita di trasferimento
                                                                            %thi e thf sono rispettivamente 0 e pigreco oppure pigreco e 2*pigreco a seconda del tipo di manovra (possibile implementazione automatica, idem a sopra)
                                                                            

%% bielliptic_bitangentTransfer
%
% Dati iniziali:
%
% a, e, i, OM, om, th --> devo partire da un orbita iniziale
% a_i, e_i, a_f, e_f, a_T1, e_T1 --> ovvero devo conoscere a,e di orbita iniziale e finale, ma anche a,e della prima orbita di trasferimento



[DeltaV1, DeltaV2, Deltat] = bielliptic_bitangentTransfer(a_i, e_i, a_f, e_f, a_T1, e_T1)       %ricavo i DeltaV e il Deltat della manovra

[RR_i, VV_i] = par2car(a_i, e_i, i_i, OM_i, om_i, 0);                                           %ricavo posizione e velocità sulla prima orbita nel pericentro            

[a_T1, e_T1, i_T1, OM_T1, om_T1, th_T1] = car2par(RR_i, VV_i + DeltaV1 * (VV_i/norm(VV_i)));    %ricavo parametri orbitali orbita di trasferimento 1 a partire dalla posizione iniziale appena ricavata e velocità VV_i + DeltaV1

plotOrbit(a_T1, e_T1, i_T1, OM_T1, om_T1, 0, pi, dth);                                          %stampo orbita di trasferimento 1, da 0 a pigreco


[RR_T1, VV_T1] = par2car(a_T1, e_T1, i_T1, OM_T1, om_T1, pi);                                   %ricavo posizione e velocità sull'orbita di trasferimento nel punto pigreco           

[a_T2, e_T2, i_T2, OM_T2, om_T2, th_T2] = car2par(RR_T1, VV_T1 + DeltaV2 * (VV_T1/norm(VV_T1)));%ricavo parametri orbitali orbita di trasferimento 2 a partire dalla posizione RR_T1 appena calcolata e velocità VV_T1 + DeltaV2

plotOrbit(a_T2, e_T2, i_T2, OM_T2, om_T2, pi, 2*pi, dth);                                       %stampo orbita di trasferimento 2 da pigreco a 2*pigreco