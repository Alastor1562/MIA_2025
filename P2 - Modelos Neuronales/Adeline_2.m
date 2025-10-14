clear all;
close all;
clc;

data = xlsread('Consumo_E.xlsx', 'Hoja1', 'A2:C25');

X1 = data(:, 2);
X2 = data(:, 1);
Y = data(:, 3);

%% Mínimos cuadrados
n = size(data,1); % Cantidad de datos

%% Construir X*, captura la forma del modelo

Xa = [ones(n,1), X1, X1.^2, X2, X1.* X2, X1.^2 .* X2];

%% Procedimiento (no tocar)

Wmc = inv(Xa' * Xa) * Xa' * Y

Yg = Xa * Wmc; % Y estimada

E = Y - Yg; % Error

J = (E' * E) / (2*n) % Costo

