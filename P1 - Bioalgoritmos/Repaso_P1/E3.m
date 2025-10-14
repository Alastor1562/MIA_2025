% Limpieza General
clear all;
close all;
clc;

%% Parámetros

np = 100000;            % Número de particulas

x1p = rand(np,1) + 170;
x2p = rand(np,1) + 0;
x3p = rand(np,1) + 100;   % Posición inicial del enjambre

x1pg = 0;
x2pg = 0;
x3pg = 0;   % Posición inicial del mejor global

x1pl = x1p; 
x2pl = x2p; 
x3pl = x3p;     % Posiciones iniciales de los mejores locales

% Desempeños iniciales
fxpg = 10000000;            % Desempeño global inicial

fxpl = ones(np,1) * fxpg;   % Desempeños locales iniciales

% Velocidad inicial
vx1 = zeros(np,1);
vx2 = zeros(np,1);
vx3 = zeros(np,1);

% Atracción
c1 = 0.1;  % Atracción hacia el local
c2 = 0.1;  % Atracción hacia el global

% Restricciones
a = 100;

%% Algortimo
for i = 1:10000 % Número de iteraciones

    E1 = 2*x1p + x2p + 0.5*x3p - 400;
    E2 = 0.5*x1p + 0.5*x2p + x3p -(100 - E1);

    fx = x1p + x2p + x3p + ...      % Función de ajuste
      a*max(400 - 2*x1p - x2p - 0.5*x3p,0) + ...
      a*max(100 - E1 - 0.5*x1p - 0.5*x2p - x3p,0) + ...
      a*max(300 - E2 - 1.5*x2p - 2*x3p,0) + ...
      a*max(-x1p,0) + a*max(-x2p,0) + a*max(-x3p,0); % Restricciones
    
    % Determinar el mínimo
    [val, ind] = min(fx);
    
    % Determinar el mejor global
    if val < fxpg
        fxpg = val;             % Actualizar del desempeño
        x1pg = x1p(ind,1);
        x2pg = x2p(ind,1);
        x3pg = x3p(ind,1);  % Actualizar la posición
    end
    
    % Determinar los mejores locales
    for p=1:np
        if fx(p,1) < fxpl(p,1)
            fxpl(p,1) = fx(p,1);      % Actualizar el desempeño local
            x1pl(p,1) = x1p(p,1);
            x2pl(p,1) = x2p(p,1);
            x3pl(p,1) = x3p(p,1);       % Actualizar la posición local
        end
    end
    
    
    %% Ecuaciones de movimiento
    % Actualizar velocidades
    vx1 = vx1 + c1 * rand() * (x1pl - x1p) + c2 * rand() * (x1pg - x1p);
    vx2 = vx2 + c1 * rand() * (x2pl - x2p) + c2 * rand() * (x2pg - x2p);
    vx3 = vx3 + c1 * rand() * (x3pl - x3p) + c2 * rand() * (x3pg - x3p);
    
    % Actualizar posiciones
    x1p = x1p + vx1;
    x2p = x2p + vx2;
    x3p = x3p + vx3;

end

fxpg = x1pg + x2pg + x3pg

x1pg, x2pg, x3pg
