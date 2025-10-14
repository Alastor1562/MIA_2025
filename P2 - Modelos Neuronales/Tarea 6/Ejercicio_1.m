clear all;
close all;
clc;

load T6_data.mat;

X = P1.x;
Y = P1.y;

%% Mínimos cuadrados
n = size(X,1); % Cantidad de datos

%% Construir X*, captura la forma del modelo
grado = 5;

for k=1:grado
    Xa = func_polinomio2(X, k);

    Wmc = inv(Xa' * Xa) * Xa' * Y;
    
    Yg = Xa * Wmc; % Y estimada
    
    E = Y - Yg; % Error
    
    J(k,1) = (E' * E) / (2*n); % Costo

end

plot(J,'b')

[Xa, coef] = func_polinomio2(X, 2);

Wmc = inv(Xa' * Xa) * Xa' * Y;  % pesos por mínimos cuadrados

Yg = Xa * Wmc; % Y estimada
    
E = Y - Yg; % Error
    
J = (E' * E) / (2*n) % Costo

% Mostrar ecuación
decod_func_polinomio2(Xa, coef, Wmc)