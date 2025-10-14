%% Limpieza general
clear all;
close all;
clc;

%% Parametros

%numero de particulas
np = 10000;

%posicion
x1p = rand(np,1)+172; %posicion inicial enjambre
x1pg = 0; %posicion del mejor global
x1pL = x1p; %posiciones iniciales de los mejores locales

x2p = rand(np,1)+1; %posicion inicial enjambre
x2pg = 0; %posicion del mejor global
x2pL = x2p; %posiciones iniciales de los mejores locales

x3p = rand(np,1)+103; %posicion inicial enjambre
x3pg = 0; %posicion del mejor global
x3pL = x3p; %posiciones iniciales de los mejores locales


%desempeños iniciales
fxpg = 1000000; %desempeño global incial
fxpL = ones(np,1) * fxpg; %desempeños locales iniciales

%velocidad inicial
vx1 = zeros(np,1);
vx2 = zeros(np,1);
vx3 = zeros(np,1);


%atraccion
c1 = 0.1; %atraccion hacia el local
c2 = 0.1; %atraccion hacia el global
c3 = 0.1; %atraccion hacia el global

a=100;

%% Algoritmo
for i = 1:10000 %generaciones

% funcion de ajuste (fitness) objetivo bukin 6

exc1 = (2*x1p + 1*x2p + 0.5*x3p) - 400;
exc2 = (0.5*x1p + 0.5*x2p + 1*x3p) - 100;

fx = (1*x1p + 1*x2p + 1*x3p) ...
    + a*max(-2*x1p -1*x2p - 0.5*x3p + 400,0) ...
    + a*max(-0.5*x1p -0.5*x2p - 1*x3p + 100 - exc1, 0) ...
    + a*max(-1.5*x2p -2*x3p + 300 - exc2, 0) ... 
    + a*max(-x1p, 0) + a*max(-x2p,0) + a*max(-x3p,0);

% determinar el mínimo
[val, ind] = min(fx);

% Determinar el mejor global
if val < fxpg
    fxpg = val; %acualizacion del desempeño
    x1pg = x1p(ind,1); %actualizacion de la posicion
    x2pg = x2p(ind,1); %actualizacion de la posicion
    x3pg = x3p(ind,1); %actualizacion de la posicion
end

% determinar los mejores locales
for p=1:np
    if fx(p,1) < fxpL(p, 1)
        fxpL(p, 1) = fx(p,1); %actualizacion del desempeño
        x1pL(p, 1) = x1p(p, 1); %actualizacion de la posicion local
        x2pL(p, 1) = x2p(p, 1); %actualizacion de la posicion local
        x3pL(p, 1) = x3p(p, 1); %actualizacion de la posicion local
    end
end
    
%% Seccion a borrar

%plot(x1p, x2p, 'b.', 0, 0, 'rx', x1pg, x2pg, 'go')
%axis([-10 10 -10 10]) %dimensiones de los ejes x y
%title(['x1pg =' num2str(x1pg), ' x2pg = ', num2str(x2pg)]);
%pause(0.1);

%% ecuaciones de movimiento
vx1 = vx1+ c1*rand()*(x1pL - x1p) + c2*rand()*(x1pg-x1p); % velocidad
vx2 = vx2+ c1*rand()*(x2pL - x2p) + c2*rand()*(x2pg-x2p); % velocidad
vx3 = vx3+ c1*rand()*(x3pL - x3p) + c2*rand()*(x3pg-x3p); % velocidad

x1p = x1p + vx1; %posicion
x2p = x2p + vx2; %posicion
x3p = x3p + vx3; %posicion


end

fxpg = 1*x1pg + 1*x2pg + 1*x3pg;

fxpg

x1pg
x2pg
x3pg