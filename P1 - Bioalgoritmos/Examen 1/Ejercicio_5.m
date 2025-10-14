%% Limpieza General
clear all;
close all;
clc;

%% Parámetros
np = 500; % Número de particulas

% Posición (inicializa dentro de cotas útiles)
x1p = 50*rand(np, 1); % x1 de [0,50]
x1pg = 0;
x1pL = x1p;

x2p = 40*rand(np, 1); % x2 de [0,40]
x2pg = 0;
x2pL = x2p;

x3p = 40*rand(np, 1); % x3 de [0,40]
x3pg = 0;
x3pL = x3p;

% Desempeños iniciales
fxpg = 1000000000000;        % Global muy grande
fxpL = ones(np,1)*fxpg;      % Locales

% Velocidad inicial
vx1 = zeros(np,1);
vx2 = zeros(np,1);
vx3 = zeros(np,1);

% Atracción
c1 = 0.1; % Atracción hacia el local
c2 = 0.1; % Atracción hacia el global

% Penalización
a = 1e4;

%% Algoritmo
for i = 1:100 % generaciones
    % Función objetivo
    % U = 50x1 + 40x2 + 60x3 - (0.2x1^2 + 0.1x2^2 + 0.2x3^2)
    U  = 50*x1p + 40*x2p + 60*x3p ...
       - (0.2*x1p.^2 + 0.1*x2p.^2 + 0.2*x3p.^2);
    fx = -U;

    % Restricciones
    % 2x1 + 3x2 + 3x3 <= 120  (maquinado)
    % 2x1 +  x2 + 2x3 <= 100  (mano de obra)
    % x1 + x2 + x3    <= 100  (almacén)
    % x1,x2,x3 >= 0
    penalty = a*( ...
        max(2*x1p + 3*x2p + 3*x3p - 120, 0) + ...
        max(2*x1p +    x2p + 2*x3p - 100, 0) + ...
        max(x1p + x2p + x3p - 100, 0)      + ...
        max(-x1p,0) + max(-x2p,0) + max(-x3p,0) ...
    );

    fx = fx + penalty;

    % Mejor global 
    [val, ind] = min(fx);
    if val < fxpg
        fxpg = val;
        x1pg = x1p(ind,1);
        x2pg = x2p(ind,1);
        x3pg = x3p(ind,1);
    end

    % Mejores locales 
    for p = 1:np
        if fx(p,1) < fxpL(p,1)
            fxpL(p,1) = fx(p,1);
            x1pL(p,1) = x1p(p,1);
            x2pL(p,1) = x2p(p,1);
            x3pL(p,1) = x3p(p,1);
        end
    end


    %% Ecuaciones de movimiento
    % Actualizar velocidades de las partículas
    r1 = rand(); r2 = rand();
    vx1 = vx1 + c1*r1*(x1pL - x1p) + c2*r2*(x1pg - x1p);
    vx2 = vx2 + c1*r1*(x2pL - x2p) + c2*r2*(x2pg - x2p);
    vx3 = vx3 + c1*r1*(x3pL - x3p) + c2*r2*(x3pg - x3p);

    % Posición
    x1p = x1p + vx1;
    x2p = x2p + vx2;
    x3p = x3p + vx3;

    % Mantener los valores dentro de los límites permitidos (Esto lo
    % sacamos de las restricciones)
    x1p = min(max(x1p, 0), 50);   % x1 entre 0 y 50
    x2p = min(max(x2p, 0), 40);   % x2 entre 0 y 40
    x3p = min(max(x3p, 0), 40);   % x3 entre 0 y 40

end

% Resultado
Ubest = 50*x1pg + 40*x2pg + 60*x3pg - (0.2*x1pg^2 + 0.1*x2pg^2 + 0.2*x3pg^2);
fprintf('Mejor solución:\n x1=%.3f, x2=%.3f, x3=%.3f,  U=%.3f\n', x1pg, x2pg, x3pg, Ubest);


