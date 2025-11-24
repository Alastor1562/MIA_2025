clear all; close all; clc;

%% Load data
% Cargo los datos desde el archivo de Excel
nombreArchivo = 'Emisiones2015.xlsx';
T = readtable(nombreArchivo, 'Sheet', 'gt_2015');

% X = variables de entrada (9)
% Y = variables de salida (CO y NOX)
X = T{:, {'AT','AP','AH','AFDP','GTEP','TIT','TAT','TEY','CDP'}};
Y = T{:, {'CO','NOX'}};

%% Partición (80% - 20% con cvpartition, igual que tu DNA)
N = size(X,1);

% cv = cvpartition(N, 'HoldOut', 0.20);
load CV5.mat

Xtrain = X(training(cv), :);
Ytrain = Y(training(cv), :);

Xtest  = X(test(cv), :);
Ytest  = Y(test(cv), :);

%% Normalización (muy importante en regresión)
muX = mean(Xtrain,1);
sigmaX = std(Xtrain,0,1);
sigmaX(sigmaX == 0) = 1;

Xtrain_norm = (Xtrain - muX)./sigmaX;
Xtest_norm  = (Xtest  - muX)./sigmaX;

%% Modelo
% Red con arquitectura fija (tu mejor modelo)
% red = feedforwardnet([60 40 30 10 10]);
% 
% % Función de entrenamiento LM (regresión)
% red.trainFcn = 'trainlm';
% 
% % Entrenamiento
% red = train(red, Xtrain_norm', Ytrain');

load RED5.mat

%% Simulación (TRAIN)
Ygtrain = (red(Xtrain_norm'))';   % salida de la red en TRAIN

% Medidas de desempeño (regresión → solo J)
Jtrain_global = perform(red, Ytrain', Ygtrain');
Jtrain_CO     = perform(red, Ytrain(:,1)', Ygtrain(:,1)');
Jtrain_NOX    = perform(red, Ytrain(:,2)', Ygtrain(:,2)');

[Jtrain_global  Jtrain_CO  Jtrain_NOX]

%% Test
Ygtest = (red(Xtest_norm'))';      % salida en TEST

Jtest_global = perform(red, Ytest', Ygtest');
Jtest_CO     = perform(red, Ytest(:,1)', Ygtest(:,1)');
Jtest_NOX    = perform(red, Ytest(:,2)', Ygtest(:,2)');

[Jtest_global  Jtest_CO  Jtest_NOX]

%% Simulación con TODOS los datos (para el criterio J < 8.1)
X_all_norm = (X - muX)./sigmaX;
Yg_all = (red(X_all_norm'))';

J_global = perform(red, Y', Yg_all');
J_CO     = perform(red, Y(:,1)', Yg_all(:,1)');
J_NOX    = perform(red, Y(:,2)', Yg_all(:,2)');

disp('Desempeño TODOS LOS DATOS')
[J_global  J_CO  J_NOX]

if J_global < 8.1
    disp('>>> Cumple criterio J < 8.1');
else
    disp('>>> NO cumple criterio J < 8.1');
end

%% Arquitectura y número de pesos
nPesos = sum(red.numWeightElements);
disp(['Numero total de pesos: ' num2str(nPesos)])

%% Predicciones para hoja "predecir"
T_pred = readtable(nombreArchivo, 'Sheet', 'predecir');
X_pred = T_pred{:, {'AT','AP','AH','AFDP','GTEP','TIT','TAT','TEY','CDP'}};

X_pred_norm = (X_pred - muX)./sigmaX;
Y_pred = (red(X_pred_norm'))';

T_pred.CO_pred  = Y_pred(:,1);
T_pred.NOX_pred = Y_pred(:,2);

disp('--- Predicciones hoja predecir ---')
disp(T_pred)