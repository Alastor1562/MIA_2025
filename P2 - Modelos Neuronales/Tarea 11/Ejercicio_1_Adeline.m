clear all; close all; clc;

load CCPP.mat

data = table2array(CCPP);

X = normalize(data(:, 1:4));
Y = data(:, 5);

%% Mínimos cuadrados
n = size(data,1); % Cantidad de datos

%% Construir X*, captura la forma del modelo
grado = 10;
for k=1:grado
    Xa = func_polinomio2(X, k);

    Wmc = inv(Xa' * Xa) * Xa' * Y;
    
    Yg = Xa * Wmc; % Y estimada
    
    E = Y - Yg; % Error
    
    J(k,1) = (E' * E) / (2*n); % Costo

end

plot(J,'b')

%% Modelo Óptimo

[Xa, coef] = func_polinomio2(X, 2);

Wmc = inv(Xa' * Xa) * Xa' * Y;  % pesos por mínimos cuadrados
Yg = Xa * Wmc; % Y estimada
E = Y - Yg; % Error 
J = (E' * E) / (2*n) % Costo

% Mostrar ecuación
decod_func_polinomio2(Xa, coef, Wmc)

%% Predicciones nuevas

new_data = normalize([21.42 43.79 1015.76 43.08]);
Xa_new_data = func_polinomio2(new_data, 2);
Yg_new_data = Xa_new_data * Wmc % Predicted output for new data