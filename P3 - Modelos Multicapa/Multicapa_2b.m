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

X = [Day Month Year data(:,1:11)]; % Entrada
Y = data(:,13); % Salida

%% Train-Test

idx = round(size(X,1) * 0.85);

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

red = feedforwardnet([10 10 10]); %% Tipo de red
% Configuración
red.trainFcn = 'trainlm'; % Entrenar por Levenberg-Marquart

red = train(red, Xtrain', Ytrain');

%% Costo de entrenamiento

Ygtrain = red(Xtrain');

J_train = perform(red,Ytrain,Ygtrain')

%% Costo de prueba

Ygtest = red(Xtest');

J_test = perform(red,Ytest,Ygtest')
