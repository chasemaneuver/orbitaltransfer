clear all
close all
clc

% ------------------------------------------------------------------------
%  Lo script stampa i valori caratteristici per l'orbita iniziale e finale
%   
%  I parametri orbitali e posizione/velocità punti iniziale/finale 
%  non vengono stampati ma sono presenti nella workspace a destra 
% ------------------------------------------------------------------------

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

%% definizione paramentri

mu = 3.986e5;

p = @(a,e) a*(1-e^2);

h = @(p) sqrt(mu*p);

rp = @(p,e) p/(1+e);

ra = @(p,e) p/(1-e);

vp = @(p,e) sqrt(mu/p) * (1+e);

va = @(p,e) sqrt(mu/p) * (1-e);

T = @(a) 2*pi * sqrt(a^3/mu);

E = @(a) -mu/(2*a);

%% stampo parametri

fprintf('\nI parametri per la prima orbita sono:')
fprintf('\n\np_i = %f [km] \nh_i = %f [km^2/s] \nrp_i = %f [km] \nra_i = %f [km] \nvp_i = %f [km/s] \nva_i = %f [km/s] \nT_i = %f [min] \nE_spec_i = %f [MJ/kg]\n\n',p(a_i,e_i),h(p(a_i,e_i)),rp(p(a_i,e_i),e_i),ra(p(a_i,e_i),e_i),vp(p(a_i,e_i),e_i),va(p(a_i,e_i),e_i),T(a_i)/60,E(a_i))

fprintf('\nI parametri per la seconda orbita sono:')
fprintf('\n\np_f = %f [km] \nh_f = %f [km^2/s] \nrp_f = %f [km] \nra_f = %f [km] \nvp_f = %f [km/s] \nva_f = %f [km/s] \nT_f = %f [min] \nE_spec_f = %f [MJ/kg]\n\n',p(a_f,e_f),h(p(a_f,e_f)),rp(p(a_f,e_f),e_f),ra(p(a_f,e_f),e_f),vp(p(a_f,e_f),e_f),va(p(a_f,e_f),e_f),T(a_f)/60,E(a_f))