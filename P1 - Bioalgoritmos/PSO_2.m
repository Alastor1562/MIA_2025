% Limpieza General
clear all;
close all;
clc;

%% Parámetros

np = 500;            % Número de particulas

x1p = rand(np,1) - 8;
x2p = rand(np,1) + 0.6;   % Posición inicial del enjambre

x1pg = 0;
x2pg = 0;           % Posición inicial del mejor global

x1pl = x1p; 
x2pl = x2p;         % Posiciones iniciales de los mejores locales

% Desempeños iniciales
fxpg = 10000000;            % Desempeño global inicial

fxpl = ones(np,1) * fxpg;   % Desempeños locales iniciales

% Velocidad inicial
vx1 = zeros(np,1);
vx2 = zeros(np,1);

% Atracción
c1 = 0.5;  % Atracción hacia el local
c2 = 0.5;  % Atracción hacia el global

% Restricciones
a1 = 100;
a2 = 100;
a3 = 100;
a4 = 100;

%% Algortimo
for i = 1:1000 % Número de iteraciones

    fx = 100 * sqrt(abs(x2p - 0.01*x1p.^2) + 0.01*abs(x1p + 10)) + ...      #Función de ajuste
      a1*max(-15-x1p,0) + a2*max(x1p+5,0) + a3*max(-3-x2p,0) + a4*max(x2p-3,0);     % Restricciones
    
    % Determinar el mínimo
    [val, ind] = min(fx);
    
    % Determinar el mejor global
    if val < fxpg
        fxpg = val;             % Actualizar del desempeño
        x1pg = x1p(ind,1);
        x2pg = x2p(ind,1);      % Actualizar la posición
    end
    
    % Determinar los mejores locales
    for p=1:np
        if fx(p,1) < fxpl(p,1)
            fxpl(p,1) = fx(p,1);      % Actualizar el desempeño local
            x1pl(p,1) = x1p(p,1);
            x2pl(p,1) = x2p(p,1);      % Actualizar la posición local
        end
    end
    
    %% Animación
    
    plot(x1p,x2p,'b.',0,0,'rx',x1pg,x2pg,'go')
    axis([-15 15 -15 15])  % Dimensiones de los ejes X,Y
    title(['x1pg = ', num2str(x1pg), ', x2pg = ', num2str(x2pg)]);
    pause(0.1)
    
    %% Ecuaciones de movimiento
    % Actualizar velocidades
    vx1 = vx1 + c1 * rand() * (x1pl - x1p) + c2 * rand() * (x1pg - x1p);
    vx2 = vx2 + c1 * rand() * (x2pl - x2p) + c2 * rand() * (x2pg - x2p);
    
    % Actualizar posiciones
    x1p = x1p + vx1;
    x2p = x2p + vx2;

end

fxpg = 100 * sqrt(abs(x2pg - 0.01*x1pg^2)) + 0.01*abs(x1pg + 10)
