clear all;
close all;
clc;

data = xlsread('TetuanCity.xlsx', 'Tetuan City power consumption', 'B2:G52417');

X = data(:, 1:5);
Y = data(:, 6);

%% Mínimos cuadrados
n = size(data,1); % Cantidad de datos

%% Construir X*, captura la forma del modelo
grado = 2;
for k=1:grado
    Xa = func_polinomio2(X, k);

    Wmc = inv(Xa' * Xa) * Xa' * Y;
    
    Yg = Xa * Wmc; % Y estimada
    
    E = Y - Yg; % Error
    
    J(k,1) = (E' * E) / (2*n); % Costo

end

plot(J,'b')

new_data = [25 80 0.1 0.05 0.14;
            30 72 0.215 0.15 0.2];

Xa_new_data = func_polinomio2(new_data, grado);

Yg_new_data = Xa_new_data * Wmc % Predicted output for new data