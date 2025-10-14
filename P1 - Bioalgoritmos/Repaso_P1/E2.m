% Limpieza General
clear all;
close all;
clc;

%% Parámetros

np = 100;            % Número de particulas

x1p = rand(np,1); %.* randi([-10, 10], np, 1);   % Posición inicial del enjambre

x1pg = rand([-10, 10]);           % Posición inicial del mejor global

x1pl = x1p;         % Posiciones iniciales de los mejores locales

% Desempeños iniciales
fxpg = 10000000;            % Desempeño global inicial
fxpl = ones(np,1) * fxpg;   % Desempeños locales iniciales

% Velocidad inicial
vx1 = zeros(np,1);

% Atracción
c1 = 0.5;  % Atracción hacia el local
c2 = 0.5;  % Atracción hacia el global

a = 100;

%% Algortimo
for i = 1:100 % Número de iteraciones

    fx = - (exp(x1p + 1).*(2*x1p - x1p.^2 + 1) - 2*x1p) ./ (exp(x1p + 1) - 1).^2 + ...
    a*max(-0.9999999 - x1p, 0) + a*max(x1p - 5, 0);     % Función de ajuste
    
    % Determinar el mínimo
    [val, ind] = min(fx);
    
    % Determinar el mejor global
    if val < fxpg
        fxpg = val;             % Actualizar del desempeño
        x1pg = x1p(ind,1);      % Actualizar la posición
    end
    
    % Determinar los mejores locales
    for p=1:np
        if fx(p,1) < fxpl(p,1)
            fxpl(p,1) = fx(p,1);      % Actualizar el desempeño local
            x1pl(p,1) = x1p(p,1);      % Actualizar la posición local
        end
    end
    
    %% Ecuaciones de movimiento
    % Actualizar velocidades
    vx1 = vx1 + c1 * rand() * (x1pl - x1p) + c2 * rand() * (x1pg - x1p);
    
    % Actualizar posiciones
    x1p = x1p + vx1;

end

fxpg = (exp(x1pg + 1).*(2*x1pg - x1pg.^2 + 1) - 2*x1pg) ./ (exp(x1pg + 1) - 1).^2

x1pg