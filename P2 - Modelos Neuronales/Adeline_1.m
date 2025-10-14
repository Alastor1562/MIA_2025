clear all;
close all;
clc;

%% Sección a Borrar
X = rand(100,1); % Valores aleatorios
Y = 5 - 2*X + 4*X.^2 - 3*X.^3 + X.^4; % Polinomio a identificar con la regresión

%% Mínimos cuadrados
n = size(X,1); % Cantidad de datos

%% Construir X*, captura la forma del modelo
% Y = W0 + W1*X
%Xa = [ones(n,1), X];

% Y = W0*sen(X) + W1*exp(-X) + W2*X
%Xa = [sin(X), exp(-X), X];

% Modelos Polinómicos
Xa = ones(n,1);

grado = 4;

for k=1:grado

    Xa = [Xa, X.^k];

    %% Procedimiento (no tocar)
    
    Wmc = inv(Xa' * Xa) * Xa' * Y;
    
    Yg = Xa * Wmc; % Y estimada
    
    E = Y - Yg; % Error
    
    J(k,1) = (E' * E) / (2*n); % Costo
    
end

plot(X,Y, 'b.', X, Yg, 'r.')
figure(2)
plot(J, 'b')

%% Gradiente Descendente
n = size(X,1);

Xa = ones(n,1);

grado = 4;

for k=1:grado
    Xa = [Xa, X.^k];
end

Wgd = rand(size(Xa,2), 1); % Pesos iniciales aleatorios

eta = 1.2; % Velocidad de convergencia

for k=1:2600000
    Yg_gd = Xa * Wgd; % Y estimada por Gradiente Descendiente

    E = Y - Yg_gd;

    J(k,1) = (E' * E) / (2*n); % Costo

    dJdW = -E' * Xa / n; % Gradiente

    Wgd = Wgd - eta * dJdW'; % Actualizar pesos usando el gradiente
end

figure(3)
subplot(1,2,1)
plot(X,Y, 'b.', X, Yg, 'r.', X, Yg_gd, 'g.')

subplot(1,2,2)
plot(J, 'b.')

[Wmc, Wgd]