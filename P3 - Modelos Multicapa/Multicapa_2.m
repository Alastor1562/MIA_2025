clear all; close all; clc;

%% Load data

load AirQualityUCI.mat

%% Manipulación de Date

% Supongamos que tu tabla se llama AirQualityUCI
AirQualityUCI.Date = datetime(AirQualityUCI.Date, 'InputFormat', 'dd-MMM-yyyy');

% Crear columnas nuevas
Day = day(AirQualityUCI.Date);
Month = month(AirQualityUCI.Date);
Year = mod(year(AirQualityUCI.Date), 100); % últimas dos cifras del año

%% Datos

data = table2array(AirQualityUCI(:,2:end));

X = [Day Month data(:,1:11)]; % Entrada
Y = data(:,12:14); % Salida

%% Train-Test

idx = round(size(X,1) * 0.8);

Xtrain = X(1:idx,:);
Xtest = X(idx+1:end,:);

Ytrain = Y(1:idx, :);
Ytest = Y(idx+1:end,:);

%% Escalado (opcional)

mu = mean(X);            % Media de cada columna
sigma = std(X);          % Desviación estándar de cada columna
Xtemp = bsxfun(@minus, Xtrain, mu);
Xtrain_norm = bsxfun(@rdivide, Xtemp, sigma); % Normalizar nuevos datos

%% Modelo

% red = feedforwardnet([10 10 10]); %% Tipo de red
% Configuración
% red.trainFcn = 'trainlm'; % Entrenar por Levenberg-Marquart

% red = train(red, Xtrain_norm', Ytrain');

load red_M2c.mat

%% Costo de entrenamiento

Ygtrain = red(Xtrain_norm');

J_train = perform(red,Ytrain,Ygtrain')
J_T_train = perform(red,Ytrain(:,1),Ygtrain(1,:)');
J_RH_train = perform(red,Ytrain(:,2),Ygtrain(2,:)');
J_AH_train = perform(red,Ytrain(:,3),Ygtrain(3,:)');

[J_T_train, J_RH_train, J_AH_train]

%% Costo de prueba

Xtemp = bsxfun(@minus, Xtest, mu);
Xtest_norm = bsxfun(@rdivide, Xtemp, sigma); % Normalizar nuevos datos

Ygtest = red(Xtest_norm');

J_test = perform(red,Ytest,Ygtest')
J_T_test = perform(red,Ytest(:,1),Ygtest(1,:)');
J_RH_test = perform(red,Ytest(:,2),Ygtest(2,:)');
J_AH_test = perform(red,Ytest(:,3),Ygtest(3,:)');

[J_T_test, J_RH_test, J_AH_test]

%% Predicciones nuevas

% Realizar predicciones con nuevos datos
newData = [1 11 0.875 2.5 1324 125 8.7 600 112 1000 95 1750 900];

 % Datos nuevos

temp = bsxfun(@minus, newData, mu);
newData_norm = bsxfun(@rdivide, temp, sigma); % Normalizar nuevos datos

YgnewData = red(newData_norm')
