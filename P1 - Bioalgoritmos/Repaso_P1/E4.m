% Limpieza General
clear all;
close all;
clc;

%% Parámetros

np = 1000;            % Número de particulas

x1p = rand(np,1);
x2p = rand(np,1);   % Posición inicial del enjambre

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
a = 1000;

%% Algortimo
for i = 1:1000 % Número de iteraciones

    % Función de ajuste a trozos
    r2 = (x1p - 1).^2 + (x2p + 2).^2;
    
    % Condición de que trozo agarrar
    inside = (r2 <= 1);
    f = zeros(np,1);
    f(inside)  = 1 - r2(inside);
    f(~inside) = exp(-r2(~inside));
    
    % Penalización cuadrática
    pen =  a*( max(x1p-5,0).^2 + max(-5-x1p,0).^2 + ...
              max(x2p-5,0).^2 + max(-5-x2p,0).^2 );
    
    % Función + penalizaciones
    fx = -f + pen;
    
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
    axis([-5 5 -5  5])  % Dimensiones de los ejes X,Y
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

r2g = (x1pg - 1)^2 + (x2pg + 2)^2;
if r2g <= 1
    fgpx = 1 - r2g
else
    fgpx = exp(-r2g)
end
