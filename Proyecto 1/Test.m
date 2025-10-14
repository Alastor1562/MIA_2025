clear all;
close all;
clc;

load data_proyecto.mat

% 1. Convertir a matriz
P = table2array(data);

% 2. Calcular rendimientos logarítmicos
R = diff(log(P));

% 3. Calcular matriz de covarianza
Sigma = cov(R);

% 4. (Opcional) Mostrar resultados
disp('Rendimientos diarios:');
disp(array2table(R, 'VariableNames', data.Properties.VariableNames));

disp('Matriz de covarianza:');
disp(Sigma);
