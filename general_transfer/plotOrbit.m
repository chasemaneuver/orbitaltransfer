function R_vect = plotOrbit(a, e, i, OM, om, th0, thf, dth,tr)

% 3d orbit plot
% 
% plotOrbit(a, e, i, OM, om, th0, thf, dth)
% 
% ------------------------------------------------------------------------
% Input arguments:
% a             [1x1]   semi-major axis                      [km]
% e             [1x1]   eccentricity                         [-]
% i             [1x1]   inclination                          [rad]
% OM            [1x1]   RAAN                                 [rad]
% om            [1x1]   pericenter anomaly                   [rad]
% th0           [1x1]   initial true anomaly                 [rad]
% thf           [1x1]   final true anomaly                   [rad]
% dth           [1x1]   true anomaly step size               [rad]
% mu            [1x1]   gravitational parameter              [km^3/s^2]
% -----------------------------------------------------------------------
% Output Arguments:
% R_vect        [3xn]   position vector matrix               [-]
% -----------------------------------------------------------------------

mu = 398600;

if nargin == 8
    tr = 0;
end

%% definizione vettore delle anomalie vere

th_vect = [th0 : dth : thf];

%% calcolo vettore di stato - [R_vect,V_vect]

n = length(th_vect);

R_vect = zeros(3,n);
V_vect = zeros(3,n);

for k = 1:n
    
    [RR, VV] = par2car(a, e, i, OM, om, th_vect(k));                        %calcolo RR e VV per ogni th i-esimo
    
    R_vect(:,k) = [,RR];                                                    %affianco il vettore colonna appena calcolato al precedente
    V_vect(:,k) = [,VV];                                                    %alla fine ottengo delle matrici dove ogni colonna raprresenta il 
                                                                            %vettore RR o VV corrispondente ad il singolo th i-esimo
end
                                                                        
%% plot Terra e orbita
    
                                                                 
earth_sphere;                                                                %stampa la terra nell'origine (dimensioni reali)
        
if tr == 'tr'
    plot3(R_vect(1,:), R_vect(2,:), R_vect(3,:),'--','DisplayName','Orbita'); %'DisplayName' permettere di aggiungere una voce nella legenda...
else
    plot3(R_vect(1,:), R_vect(2,:), R_vect(3,:),'Linewidth',2,...           
                                                'DisplayName','Orbita');
end 

lgd = legend('-DynamicLegend');                                             %...insieme a legend('-DynamicLegend') permette di aggiungere voci una dopo l'altra, senza che si sovrascrivano       

% %% plot campo velocità
%   
% passo = ceil(length(R_vect)/20);                                            %definisco il passo (vedi sotto) (ps. 20 è del tutto casuale)
%         
% quiver3(R_vect(1,1:passo:end),R_vect(2,1:passo:end),...
%         R_vect(3,1:passo:end),...                                           %quiver(x,y,z,u,v,w,s) stampa delle frecce (vetttori) aventi origine in
%         V_vect(1,1:passo:end),V_vect(2,1:passo:end),...                     %x,y,z e con componenti u,v,w, dopo averli moltiplicati per un fattore s
%         V_vect(3,1:passo:end),1,'r','DisplayName','Campo velocità');        %in questo caso x,y e z sono solo alcuni punti dell'orbita, distaziati di "passo", per evitare di stampare troppi vettori velocità   
%                                                                                                                                                                       
%% plot assi ECI
         
 X = [0 0 0]';
 Y = [0 0 0]';                                                              %per stampare gli assi del sistema ECI definisco 
 Z = [0 0 0]';                                                              %l'origine (X,Y,Z) e le componenti (I,J,K)
 I = [1 0 0]'; 
 J = [0 1 0]'; 
 K = [0 0 1]';

 quiver3(X,Y,Z,I,J,K,2e4,'k','linewidth',1,'DisplayName','Assi ECI')

%  text(2.1e4,0,0,'X','fontsize',16)                                          %stampa le lettere X,Y e Z vicino agli assi nelle posizioni x,y,z 
%  text(0,2.1e4,0,'Y','fontsize',16)                                          %in questo caso x,y,z è la lunghezza degli assi ECI (2e4) + 1000 km (=2.1e4)
%  text(0,0,2.1e4,'Z','fontsize',16)
% 
% %% plot vettore momento angolare h
%         
% h_vect = cross(R_vect(:,1),V_vect(:,1));                                    %vettore momento angolare h
% 
% quiver3(0,0,0,h_vect(1),h_vect(2),h_vect(3),2e4/norm(h_vect),...
%        'linewidth',2,'DisplayName','h');                                    %stampa vettore "h" e lo ridimensiona della stessa lunghezza degli assi
% 
% text(h_vect(1)*(2.1e4/norm(h_vect)),...
%      h_vect(2)*(2.1e4/norm(h_vect)),...
%      h_vect(3)*(2.1e4/norm(h_vect)), 'h','fontsize',18,'DisplayName','h')                     %stampa "h" vicino al vettore
%         
% %% plot vettore eccentricità e
%                 
% e_vect = (cross(V_vect(:,1),h_vect)/mu)-(R_vect(:,1)/norm(R_vect(:,1)));    %vettore eccentricità e
%                                  
% 
% quiver3(0,0,0,e_vect(1),e_vect(2),e_vect(3),2e4/norm(e_vect),...            %stampa vettore "e" e lo ridimensiona della stessa lunghezza degli assi
%         'linewidth',2,'DisplayName','e');
% 
% text(e_vect(1)*(2.1e4/norm(e_vect)),...
%      e_vect(2)*(2.1e4/norm(e_vect)),...
%      e_vect(3)*(2.1e4/norm(e_vect)), 'e','fontsize',18)                     %stampa "e" vicino al vettore
%         
% %% plot piano orbitale
%         
% f=fill3(R_vect(1,:),R_vect(2,:),R_vect(3,:),'r',...                         %colora internamente il poligono con estremi i punti dell'orbita
%         'DisplayName','Piano orbitale');
% 
% set(f,'facealpha',0.5);                                                     %definisce opacità
%        
% %% plot vettore linea dei nodi N
%          
% K = [0 0 1];                                                                %ridefinisco versore K, necessario se non seleziono di stampare gli assi
% 
% N_vect = cross(K,h_vect)/norm(cross(K,h_vect));                             %versore linea dei nodi "N"
% 
% quiver3(0,0,0,N_vect(1),N_vect(2),N_vect(3),2e4/norm(N_vect),...            %stampa vettore "N" e lo ridimensiona della stessa lughezza degli assi
%        'linewidth',2,'DisplayName','N')
% 
% text(N_vect(1)*(2.1e4/norm(N_vect)),...                                     %stampa "N" vicino al vettore
%      N_vect(2)*(2.1e4/norm(N_vect)),...
%      N_vect(3)*(2.1e4/norm(N_vect)), 'N','fontsize',18)   

grid on
axis image
hold off

%% plot velocità
% 
% figure
% 
% plot(th_vect,V_vect(1,:), th_vect,V_vect(2,:),th_vect,V_vect(3,:));         %stampa la componente x,y e z di tutti i vettori velocità rispetto a theta
% hold on                                                                 
% plot([th_vect(1) th_vect(end)],[0 0],'--')                                  %stampa linea velocita nulla
% 
% axis([th_vect(1),th_vect(end),min(min(V_vect)),max(max(V_vect))])       
% legend('V_x','V_y','V_z', 'Location','Best')                                               
% xlabel('Theta [rad]')
% ylabel('V [km/s]')

end