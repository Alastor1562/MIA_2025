% Limpieza General
clear all;
close all;
clc;

%% Sección a borrar
x = -10:0.01:10;
y = 10+x.^2 - 15*cos(5*x);

%% Parámetros

np = 50;            % Número de particulas

x1p = rand(np,1) .* randi([-10, 10], np, 1);   % Posición inicial del enjambre

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

%% Algortimo
for i = 1:100 % Número de iteraciones

    fx = 10+x1p.^2 - 15*cos(5*x1p);     % Función de ajuste
    
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
    
    %% Sección a borrar
    
    plot(x,y,'b-',x1p,fx,'rx',x1pg,fxpg,'go')
    axis([-10 10 -20 120])  % Dimensiones de los ejes X,Y
    title(['x1pg', num2str(x1pg)]);
    pause(0.1)
    
    %% Ecuaciones de movimiento
    % Actualizar velocidades
    vx1 = vx1 + c1 * rand() * (x1pl - x1p) + c2 * rand() * (x1pg - x1p);
    
    % Actualizar posiciones
    x1p = x1p + vx1;

end
