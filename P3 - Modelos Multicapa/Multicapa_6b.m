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

n = numel(unique(Ytrain));

%% Dummies
Ytraind = zeros(size(Ytrain,1), numel(unique(Ytrain)));

Ytraind(Ytrain(:,1)==0,1) = 1;
Ytraind(Ytrain(:,1)==1,2) = 1;
Ytraind(Ytrain(:,1)==2,3) = 1;

%% Modelo
red = feedforwardnet([10 10 10]);  % Tipo de red
% Configurar red
red.trainFcn = 'trainrp'; % trainrp / trainscg (para entrenamiento de clasificación)

% Entrenamiento
red = train(red, Xtrain', Ytraind');

%% Simulación
Ygtraind = round((red(Xtrain'))');

Ygtraind(Ygtraind(:,1) > 1,1) = 1;
Ygtraind(Ygtraind(:,1) < 0,1) = 0;

Ygtraind(Ygtraind(:,2) > 1,2) = 1;
Ygtraind(Ygtraind(:,2) < 0,2) = 0;

Ygtraind(Ygtraind(:,3) > 1,3) = 1;
Ygtraind(Ygtraind(:,3) < 0,3) = 0;

%% A1
A1 = confusionmat(Ytraind(:,1), Ygtraind(:,1));
figure(1)
confusionchart(A1, [0 1])

% Métricas de A1
exatrain1 = sum(diag(A1)) / sum(A1(:));
pretrain1 = A1(2,2) / sum(A1(2,:)); 
rectrain1 = A1(2,2) / sum(A1(:,2));

%% A2
A2 = confusionmat(Ytraind(:,2), Ygtraind(:,2));
figure(2)
confusionchart(A2, [0 1])

% Métricas de A1
exatrain2 = sum(diag(A2)) / sum(A2(:));
pretrain2 = A2(2,2) / sum(A2(2,:)); 
rectrain2 = A2(2,2) / sum(A2(:,2));

%% A3
A3 = confusionmat(Ytraind(:,3), Ygtraind(:,3));
figure(3)
confusionchart(A3, [0 1])

% Métricas de A1
exatrain3= sum(diag(A3)) / sum(A3(:));
pretrain3 = A3(2,2) / sum(A3(2,:)); 
rectrain3 = A3(2,2) / sum(A3(:,2));

%% Métricas generales
exatrain = mean([exatrain1 exatrain2 exatrain3]);
pretrain = mean([pretrain1 pretrain2 pretrain3]);
rectrain = mean([rectrain1 rectrain2 rectrain3]);

J = perform(red, Ytraind, Ygtraind);

[J exatrain pretrain rectrain]