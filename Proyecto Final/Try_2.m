clear all; close all; clc;

%% Carga de Datos
load datos.mat

data = [MaternalHealthRiskDataSet(:,1:6) MaternalHealthRiskDataSet(:,8)];
data = table2array(data);

%% Partición
X = data(:,1:6);
Y = data(:,7);

% X = [X, X.^2, sqrt(abs(X))];

cv = cvpartition(Y, 'HoldOut', 0.15);

% Datos de entrenamiento.
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
% Datos de prueba.
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);

% maximo = max(Xtrain);
% 
% Xtrain = Xtrain./maximo;
% Xtest = Xtest ./ maximo;

% Escalar (normalizacion)
media = mean(Xtrain);
desviacion = std(Xtrain);

Xtemp = bsxfun(@minus, Xtrain, media);
Xtrain_n = bsxfun(@rdivide, Xtemp, desviacion);

Xtemp = bsxfun(@minus, Xtest, media);
Xtest_n = bsxfun(@rdivide, Xtemp, desviacion);