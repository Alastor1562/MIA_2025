clear all; close all; clc;

load CCPP.mat

data = table2array(CCPP);

%% Train-Test

index = round(size(data,1) * 0.8);

X_train = normalize(data(1:index, 1:4));
Y_train = data(1:index, 5);

X_test = normalize(data(index+1:end, 1:4));
Y_test = data(index+1:end, 5);

%% Mínimos cuadrados
n_train = size(X_train,1); % Cantidad de datos de entrenamiento

%% Construir X*, captura la forma del modelo
grado = 4;
for k=1:grado
    Xa = func_polinomio2(X_train, k);

    Wmc = inv(Xa' * Xa) * Xa' * Y_train;
    
    Yg = Xa * Wmc; % Y estimada
    
    E = Y_train - Yg; % Error
    
    Jtrain(k,1) = (E' * E) / (2*n_train); % Costo

end

plot(Jtrain,'b')

%% Modelo Óptimo

g_opt = 2;

n_test = size(X_test,1);

[Xa, coef] = func_polinomio2(X_train, g_opt);
Wmc = inv(Xa' * Xa) * Xa' * Y_train;  % pesos por mínimos cuadrados

Xa_test = func_polinomio2(X_test, g_opt);
Yg = Xa_test * Wmc; % Y estimada
E = Y_test - Yg; % Error 
J = (E' * E) / (2*n_test) % Costo

% Mostrar ecuación
decod_func_polinomio2(Xa, coef, Wmc)

%% Predicciones nuevas

new_data = normalize([21.42 43.79 1015.76 43.08]);
Xa_new_data = func_polinomio2(new_data, 2);
Yg_new_data = Xa_new_data * Wmc % Predicted output for new data