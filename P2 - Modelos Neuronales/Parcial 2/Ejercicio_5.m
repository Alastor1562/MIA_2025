clear all; close all; clc;

load airfoil.txt

%% Train-Test

data = airfoil;

index = round(size(data,1) * 0.8);

X = normalize(data(:,1:5));

Xtrain = X(1:index,:);
Xtest = X(index+1:end, :);

X1 = Xtrain(:,1);
X2 = Xtrain(:,2);
X3 = Xtrain(:,3);
X4 = Xtrain(:,4);
X5 = Xtrain(:,5);

Y = data(:,6);

Ytrain = Y(1:index,:);
Ytest = Y(index+1:end, :);

%% Número de datos

n = size(Xtrain,1);

%% Modelo a)

Xa = [ones(n,1), X1, X3, X5, X2.^2, X5.*X1, X1.*X3, (X4.^2).*X2, X4.^2, X2.^3];

Wmc_a = inv(Xa' * Xa) * Xa' * Ytrain;
imprimir_coeficientes(Wmc_a)

Yg = Xa * Wmc_a; % Y estimada    
E = Ytrain - Yg; % Error
J_a = (E' * E) / (2*n) % Costo

%% Modelo b)

[Xa coef] = func_polinomio2(Xtrain, 2);

Wmc_b = inv(Xa' * Xa) * Xa' * Ytrain;
decod_func_polinomio2(Xa, coef, Wmc_b)

Yg = Xa * Wmc_b; % Y estimada    
E = Ytrain - Yg; % Error
J_b = (E' * E) / (2*n) % Costo

%% Estimaciones

new_data = [1000 1.5 0.2286 39.6 0.00229336;
            6300 0 0.1524 55.5 0.00253511;
            315 2.7 0.0254 71.3 0.00372371;
            12500 5.4 0.1524 31.7 0.111706];

new_data = normalize(new_data);

Xa_new_data = func_polinomio2(new_data, 2);

Yg_new_data = Xa_new_data * Wmc_b