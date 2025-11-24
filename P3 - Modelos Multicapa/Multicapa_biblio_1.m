clear all; close all; clc;

%% Load data

load dna.mat;

%% Separación de datos
X = dna(:, 2:end);  % Variables de entrada

Y = dna(:,1);  % salidas de 1s y 0s

%% Partición
cv = cvpartition(Y, 'HoldOut', 0.2);
Xtrain = X(training(cv), :);
Ytrain = Y(training(cv), :);

Xtest = X(test(cv), :);
Ytest = Y(test(cv), :);

datatrain = [Xtrain Ytrain];
datatest = [Xtest Ytest];

load trainedModel_1.mat

trainedModel.predictFcn(Xtest)